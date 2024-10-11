`timescale 1ns / 1ps

module reg_EX_MEM(
    input wire clk,
    input wire rst,
    input wire[31:0] ex_C,
    input wire[31:0] ex_pc4,
    input wire[31:0] ex_ext,
    input wire[1:0] ex_ram_wdin_op,
    input wire[2:0] ex_ram_rb_op,
    input wire ex_ram_we,
    input wire ex_rf_we,
    input wire[1:0] ex_rf_wsel,
    input wire[31:0] ex_rD2,
    input wire[4:0] ex_wR,
    input wire[31:0] ex_pc,
    output reg[31:0] mem_C,
    output reg[31:0] mem_pc4,
    output reg[31:0] mem_ext,
    output reg[1:0] mem_ram_wdin_op,
    output reg[2:0] mem_ram_rb_op,
    output reg mem_ram_we,
    output reg mem_rf_we,
    output reg[1:0] mem_rf_wsel,
    output reg[31:0] mem_rD2,
    output reg[4:0] mem_wR,
    output reg[31:0] mem_pc
    );
    always@(posedge clk or posedge rst)begin
        if (rst)begin
            mem_C<=32'd0;
            mem_pc4<=32'd0;
            mem_ext<=32'd0;
            mem_ram_wdin_op<=2'd0;
            mem_ram_rb_op<=3'd0;
            mem_ram_we<=1'b0;
            mem_rf_we<=1'b0;
            mem_rf_wsel<=2'd0;
            mem_rD2<=32'd0;
            mem_wR<=5'd0;
            mem_pc<=32'd0;
        end else begin
            mem_C<=ex_C;
            mem_pc4<=ex_pc4;
            mem_ext<=ex_ext;
            mem_ram_wdin_op<=ex_ram_wdin_op;
            mem_ram_rb_op<=ex_ram_rb_op;
            mem_ram_we<=ex_ram_we;
            mem_rf_we<=ex_rf_we;
            mem_rf_wsel<=ex_rf_wsel;
            mem_rD2<=ex_rD2;
            mem_wR<=ex_wR;
            mem_pc<=ex_pc;
        end
    end
endmodule
