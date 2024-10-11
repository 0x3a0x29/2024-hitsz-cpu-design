`timescale 1ns / 1ps

module ifetch(
    input wire reset,
    input wire clk,
    input wire pc_sel,
    input wire[31:0] alu,
    input wire[31:0] offset,
    input wire br,
    input wire[1:0] npc_op,
    input wire stop,
    input wire[31:0] ex_pc,
    output wire[31:0] pc4,
    output wire[31:0] pc,
    output wire branch
    );
    wire[31:0] npc;
    wire[31:0] npc_din=pc_sel?alu:npc;
    NPC npc_module(
        .op(npc_op),
        .br(br),
        .offset(offset),
        .PC(pc),
        .npc(npc),
        .pc4(pc4),
        .stop(stop),
        .ex_pc(ex_pc),
        .branch(branch)
    );
    PC pc_module(
        .clk(clk),
        .rst(reset),
        .pc(pc),
        .npc(npc_din)
    );
endmodule

