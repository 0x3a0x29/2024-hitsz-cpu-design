`timescale 1ns / 1ps

module execute(
    input wire [31:0] pc,
    input wire[31:0] rD1,
    input wire[31:0] ext,
    input wire[31:0] rD2,
    input wire [3:0] alu_op,
    input wire alua_sel,
    input wire alub_sel,
    output wire [31:0] C,
    output wire f
    );
    wire[31:0] A;
    wire[31:0] B;
    assign A=alua_sel?rD1:pc;
    assign B=alub_sel?rD2:ext;
    ALU alu_module(
        .A(A),
        .B(B),
        .op(alu_op),
        .f(f),
        .C(C)
    );
endmodule
