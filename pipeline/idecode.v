`timescale 1ns / 1ps

module idecode(
    input wire[31:7] inst,
    input wire [2:0] sext_op,
    input wire rf_we,
    input wire [1:0] rf_wsel,
    input wire clk,
    input wire[31:0] ALUC,
    input wire[31:0] rdo,
    input wire[31:0] pc4,
    input wire[4:0] wR,
    input wire[31:0] wb_ext,
    output wire [31:0] rD1,
    output wire [31:0] rD2,
    output wire [31:0] id_ext,
    output reg [31:0] wD
);
    parameter WD_ALUC=2'h0;
    parameter WD_RAM=2'h1;
    parameter WD_EXT=2'h2;
    parameter WD_PC4=2'h3;
    always@(*)begin
        case(rf_wsel)
             WD_ALUC:begin
                wD=ALUC;
             end
             WD_RAM:begin
                wD=rdo;
             end
             WD_EXT:begin
                wD=wb_ext;
             end
             WD_PC4:begin
                wD=pc4;
             end
             default:begin
                wD=32'h0;
             end
        endcase
    end
    RF rf_module(
        .rR1(inst[19:15]),
        .rR2(inst[24:20]),
        .wR(wR),
        .we(rf_we),
        .clk(clk),
        .wD(wD),
        .rD1(rD1),
        .rD2(rD2)
    );
    SEXT sext_mpdule(
        .op(sext_op),
        .din(inst[31:7]),
        .ext(id_ext)
    );
endmodule
