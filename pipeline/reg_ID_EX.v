`timescale 1ns / 1ps

module reg_ID_EX(
    input wire clk,
    input wire rst,
    input wire clear,
    input wire[31:0] id_rD1,
    input wire[31:0] id_rD2,
    input wire[31:0] id_pc,
    input wire id_rf_we,
    input wire[1:0] id_rf_wsel,
    input wire id_pc_sel,
    input wire[1:0] id_ram_wdin_op,
    input wire[2:0] id_ram_rb_op,
    input wire id_ram_we,
    input wire[1:0] id_npc_op,
    input wire[31:0] id_ext,
    input wire[31:0] id_pc4,
    input wire[3:0] id_alu_op,
    input wire[4:0] id_wR,
    input wire id_alua_sel,
    input wire id_alub_sel,
    output reg[31:0] ex_rD1,
    output reg[31:0] ex_rD2,
    output reg[31:0] ex_pc,
    output reg ex_rf_we,
    output reg[1:0] ex_rf_wsel,
    output reg ex_pc_sel,
    output reg[1:0] ex_ram_wdin_op,
    output reg[2:0] ex_ram_rb_op,
    output reg ex_ram_we,
    output reg[31:0] ex_ext,
    output reg[31:0] ex_pc4,
    output reg[3:0] ex_alu_op,
    output reg[1:0] ex_npc_op,
    output reg[4:0] ex_wR,
    output reg ex_alua_sel,
    output reg ex_alub_sel,
    
    input wire rs1_hazard,
    input wire rs2_hazard,
    input wire[31:0] hazard_rD1,
    input wire[31:0] hazard_rD2
    );
    always@(posedge clk or posedge rst)begin
        if (rst)begin
            ex_rD1<=32'd0;
            ex_pc<=32'd0;
            ex_rD2<=32'd0;
            ex_rf_we<=1'b0;
            ex_rf_wsel<=3'd0;
            ex_pc_sel<=1'b0;
            ex_ram_wdin_op<=2'd0;
            ex_ram_rb_op<=3'd0;
            ex_ram_we<=1'b0;
            ex_ext<=32'd0;
            ex_pc4<=32'd0;
            ex_alu_op<=4'd0;
            ex_npc_op<=2'd0;
            ex_wR<=5'd0;
            ex_alua_sel<=1'b0;
            ex_alub_sel<=1'b0;
        end else if(clear)begin
            ex_rD1<=32'd0;
            ex_pc<=32'd0;
            ex_rD2<=32'd0;
            ex_rf_we<=1'b0;
            ex_rf_wsel<=3'd0;
            ex_pc_sel<=1'b0;
            ex_ram_wdin_op<=2'd0;
            ex_ram_rb_op<=3'd0;
            ex_ram_we<=1'b0;
            ex_ext<=32'd0;
            ex_pc4<=32'd0;
            ex_alu_op<=4'd0;
            ex_npc_op<=2'd0;
            ex_wR<=5'd0;
            ex_alua_sel<=1'b0;
            ex_alub_sel<=1'b0;
        end else begin
            ex_rD1<=rs1_hazard?hazard_rD1:id_rD1;
            ex_pc<=id_pc;
            ex_rD2<=rs2_hazard?hazard_rD2:id_rD2;
            ex_rf_we<=id_rf_we;
            ex_rf_wsel<=id_rf_wsel;
            ex_pc_sel<=id_pc_sel;
            ex_ram_wdin_op<=id_ram_wdin_op;
            ex_ram_rb_op<=id_ram_rb_op;
            ex_ram_we<=id_ram_we;
            ex_ext<=id_ext;
            ex_pc4<=id_pc4;
            ex_alu_op<=id_alu_op;
            ex_npc_op<=id_npc_op;
            ex_wR<=id_wR;
            ex_alua_sel<=id_alua_sel;
            ex_alub_sel<=id_alub_sel;
        end
    end
endmodule
