`timescale 1ns / 1ps

module main_control (
    input wire clk,
    input wire reset,
    input wire signed [15:0] data_x,
    input wire signed [15:0] data_y,
    input wire signed [15:0] data_z,
    output reg [3:0] direction // 4-bit representation for directions
);

    // Define different thresholds for each axis
    localparam signed [15:0] x_threshold = 500;  // Threshold for x-axis
    localparam signed [15:0] y_threshold = 500;  // Threshold for y-axis
    localparam signed [15:0] z_threshold = 500;  // Threshold for z-axis

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            direction <= 4'b0000; // Default to no movement
        end else begin
            direction <= 4'b0000; // Default: No movement

            // Check conditions for data_x (left-right)
            if (data_x > x_threshold) begin
                direction <= 4'b1000; // Right
            end
            else if (data_x < -x_threshold) begin
                direction <= 4'b0100; // Left
            end

            // Check conditions for data_y (up-down)
            if (data_y > y_threshold) begin
                direction <= 4'b0001; // Up
            end
            else if (data_y < -y_threshold) begin
                direction <= 4'b0010; // Down
            end

            // Check conditions for data_z (optional, forward-backward)
            // Uncomment if you want to check z-axis movement as well
            
            if (data_z > z_threshold) begin
                direction <= 4'b0011; // Forward (if you want to add more directions)
            end
            else if (data_z < -z_threshold) begin
                direction <= 4'b0110; // Backward
            end
            
        end
    end
endmodule
