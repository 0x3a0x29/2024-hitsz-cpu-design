`timescale 1ns / 1ps

module btn(
    input wire        rst,
    input wire        clk,
    input wire [31:0] addr,
    
    input wire [ 4:0] button,
    
    output reg [31:0] rdata 
);

    always@(*)begin
        case(button)
            5'b00001:rdata=32'h11111111;
            5'b00010:rdata=32'h22222222;
            5'b00100:rdata=32'h44444444;
            5'b01000:rdata=32'h88888888;
            5'b10000:rdata=32'hffffffff;
            default:rdata=32'h0;
        endcase
    end

endmodule