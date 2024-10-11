`timescale 1ns / 1ps

module reg_IF_ID(
    input wire clk,
    input wire rst,
    input wire clear,
    input wire stop,
    input wire[31:0] if_pc,
    input wire[31:0] if_pc4,
    input wire[31:0] if_inst,
    output reg[31:0] id_pc,
    output reg[31:0] id_pc4,
    output reg[31:0] id_inst
    );
    always@(posedge clk or posedge rst)begin
        if (rst)begin
            id_pc<=32'd0;
            id_pc4<=32'd0;
            id_inst<=32'd0;
        end else if(clear)begin
            id_pc<=32'd0;
            id_pc4<=32'd0;
            id_inst<=32'd0;
        end else if(stop)begin
            id_pc<=id_pc;
            id_pc4<=id_pc4;
            id_inst<=id_inst;
        end else begin
            id_pc<=if_pc;
            id_pc4<=if_pc4;
            id_inst<=if_inst;
        end
    end
endmodule
