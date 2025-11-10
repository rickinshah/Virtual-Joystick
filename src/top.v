`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2025 08:44:56 AM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clock, // 100 MHz onboard clock
    input reset,
    //oled interface
    output oled_spi_clk,
    output oled_spi_data,
    output oled_vdd,
    output oled_vbat,
    output oled_reset_n,
    output oled_dc_n
);

//    reg [8*64-1:0] myString = "       TOP                                                      ";
    //reg [8*64-1:0] myString = "                                                      DOWN      ";
    //reg [8*64-1:0] myString = "                SIDE1                                            ";
    //reg [8*64-1:0] myString = "                           SIDE2                                ";
    localparam stringLen = 64;
    reg [(8*stringLen)-1:0] myString = "       TOP      SIDE1                      SIDE2      DOWN      ";
    
    reg [1:0] state;
    reg [7:0] sendData;
    reg sendDataValid;
    integer byteCounter;
    wire sendDone;
    
    integer stringCount;
    reg updateString;
    
    localparam IDLE = 'd0,
               SEND = 'd1,
               DONE = 'd2;
               
    
    always @(posedge clock)
    begin
        if(reset)
        begin
            updateString <= 0;
            stringCount <= 0;
            myString <= "       TOP                                                      ";
        end
        else
        begin
            stringCount <= stringCount + 1;
            if(stringCount == 1000000000)
            begin
                updateString <= 1'b1;
                myString = "       TOP      SIDE1                      SIDE2      DOWN      ";
            end
            else if(stringCount == 2000000000)
            begin
                updateString <= 1'b1;
                myString = "       TOP                                            DOWN      ";
            end
            else
            begin
                updateString <= 1'b0;
            end
        end
    end
    
    always @(posedge clock)
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
                        sendData <= myString[(byteCounter*8-1)-:8];
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
                        state <= IDLE;
                    else
                        state <= DONE;
                end
            endcase
        end
        
    end

    oledControl OC(
        .clock(clock), // 100 MHz onboard clock
        .reset(reset),
        //oled interface
        .oled_spi_clk(oled_spi_clk),
        .oled_spi_data(oled_spi_data),
        .oled_vdd(oled_vdd),
        .oled_vbat(oled_vbat),
        .oled_reset_n(oled_reset_n),
        .oled_dc_n(oled_dc_n),
        //
        .sendData(sendData),
        .sendDataValid(sendDataValid),
        .updateString(updateString),
        .sendDone(sendDone)
    );
endmodule
