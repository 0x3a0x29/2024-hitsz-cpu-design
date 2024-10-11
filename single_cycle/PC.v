`timescale 1ns / 1ps

module PC(
    input wire rst,
    input wire clk,
    input wire[31:0] npc,
    output reg[31:0] pc
    );
    reg rst_s;
    always@(posedge clk or posedge rst)begin
        if (rst)begin
            pc<=32'h0;
        end
        else if (rst_s)begin
            pc<=32'h0;
        end
        else begin
            pc<=npc;
        end
    end
    always@(posedge clk or posedge rst)begin
        if (rst)begin
            rst_s<=1'b1;
        end
        else begin
            rst_s<=1'b0;
        end
    end
endmodule
