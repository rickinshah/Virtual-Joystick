`timescale 1ns / 1ps

module top_final (
    input CLK100MHZ,             
    input reset,                 
    input ACL_MISO,              
    output ACL_MOSI,             
    output ACL_SCLK,             
    output ACL_CSN,              
    output oled_spi_clk,         
    output oled_spi_data,        
    output oled_vdd,             
    output oled_vbat,            
    output oled_reset_n,         
    output oled_dc_n             
);

    wire clk_4MHz;
    iclk_gen clock_generation (
        .CLK100MHZ(CLK100MHZ),
        .clk_4MHz(clk_4MHz)
    );

    wire [44:0] acl_data;
    spi_master master (
        .iclk(clk_4MHz),
        .miso(ACL_MISO),
        .sclk(ACL_SCLK),
        .mosi(ACL_MOSI),
        .cs(ACL_CSN),
        .acl_data(acl_data)
    );

    wire signed [14:0] data_x =  acl_data[14:0];   
    wire signed [14:0] data_y =  acl_data[29:15];  
    wire signed [14:0] data_z =  acl_data[44:30];  

    wire [3:0] direction;
    main_control main_control_inst (
        .clk(CLK100MHZ),
        .reset(reset),
        .data_x(data_x),
        .data_y(data_y),
        .data_z(data_z),
        .direction(direction)
    );

    integer byteCounter;
    localparam IDLE = 'd0,
               SEND = 'd1,
               DONE = 'd2;
    reg [1:0] state;
    integer stringCount;

    reg [7:0] sendData;
    reg sendDataValid;
    wire sendDone;
    
    localparam stringLen = 64; 
    reg [(8*stringLen)-1:0] message;
    reg updateString;

    
    reg [26:0] refresh_timer; 

    always @(posedge CLK100MHZ) begin
        stringCount <= stringCount + 1;
        if(stringCount == 500000)
        begin
        updateString <= 1'b1;
        case (direction)
            4'b1000: message = "---------------------FLAT---------------------------------------";
            4'b0100: message = "UNFLAT";
            4'b0001: message = "       ^               |               |               UP       ";
            4'b0010: message = "       |               |               v              DOWN      ";
            4'b0011: message = "                      ---->                           RIGHT     ";
            4'b0110: message = "                      <----                           LEFT      ";
            default: message = "                                                                ";
        endcase
        stringCount <= 0;
        end
        else begin
            updateString <= 1'b0;
        end
    end

    always @(posedge CLK100MHZ or posedge reset)
    begin
        if(reset)
        begin
            state <= IDLE;
            byteCounter <= stringLen;
            sendDataValid <= 1'b0;
        end
        else
        begin
            case(state)
                IDLE: begin
                    if(!sendDone)
                    begin
                        sendData <= message[(byteCounter*8-1)-:8];
                        sendDataValid <= 1'b1;
                        state <= SEND;
                    end
                end
                SEND: begin
                    if(sendDone)
                    begin
                        sendDataValid <= 1'b0;
                        byteCounter <= byteCounter - 1;
                        if(byteCounter != 1)
                            state <= IDLE;
                        else
                            state <= DONE;
                    end
                end
                DONE: begin
                    if(updateString)
                    begin
                        byteCounter <= stringLen;
                        state <= IDLE;
                    end
                    else
                        state <= DONE;
                end
            endcase
        end
        end
    oledControl oled_control_inst (
        .clock(CLK100MHZ),
        .reset(reset),
        .oled_spi_clk(oled_spi_clk),
        .oled_spi_data(oled_spi_data),
        .oled_vdd(oled_vdd),
        .oled_vbat(oled_vbat),
        .oled_reset_n(oled_reset_n),
        .oled_dc_n(oled_dc_n),
        .sendData(sendData),
        .sendDataValid(sendDataValid),
        .sendDone(sendDone),
        .updateString(updateString)
    );
endmodule