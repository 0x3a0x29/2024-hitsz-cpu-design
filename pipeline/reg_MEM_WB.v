`timescale 1ns / 1ps

module reg_MEM_WB(
    input wire clk,
    input wire rst,
    input wire[31:0] mem_rdo,
    input wire mem_rf_we,
    input wire[1:0] mem_rf_wsel,
    input wire[31:0] mem_C,
    input wire[4:0] mem_wR,
    input wire[31:0] mem_pc4,
    input wire[31:0] mem_ext,
    input wire[31:0] mem_pc,
    output reg[31:0] wb_rdo,
    output reg wb_rf_we,
    output reg[1:0] wb_rf_wsel,
    output reg[31:0] wb_C,
    output reg[4:0] wb_wR,
    output reg[31:0] wb_pc4,
    output reg[31:0] wb_ext,
    output reg[31:0] wb_pc
    );
    always@(posedge clk or posedge rst)begin
        if (rst)begin
            wb_rdo<=32'd0;
            wb_rf_we<=1'b0;
            wb_rf_wsel<=2'd0;
            wb_C<=32'd0;
            wb_wR<=5'd0;
            wb_pc4<=32'd0;
            wb_ext<=32'd0;
            wb_pc<=32'd0;
        end else begin
            wb_rdo<=mem_rdo;
            wb_rf_we<=mem_rf_we;
            wb_rf_wsel<=mem_rf_wsel;
            wb_C<=mem_C;
            wb_wR<=mem_wR;
            wb_pc4<=mem_pc4;
            wb_ext<=mem_ext;
            wb_pc<=mem_pc;
        end
    end
endmodule
