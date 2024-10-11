`timescale 1ns / 1ps

module sw(
    input wire        rst,
    input wire        clk,
    input wire [31:0] addr,
    
    input wire [23:0] sw,
    
    output wire [31:0] rdata 
);

    assign rdata = { 8'd0 , sw };

endmodule
