`timescale 1ns / 1ps

module led(
    input wire        rst,
    input wire        clk,
    input wire [31:0] addr,
    input wire        we,
    input wire [31:0] wdata,
    
    output reg [23:0] led 
);

    always @(posedge clk or posedge rst) begin
        if(rst) led <= 32'd0;
        else if(~we) led <= led;
        else led <= wdata;
    end

endmodule
