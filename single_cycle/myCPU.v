`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
`ifdef RUN_TRACE
    output wire [15:0]  inst_addr,
`else
    output wire [13:0]  inst_addr,
`endif
    input  wire [31:0]  inst,
    
    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_we,
    output wire [31:0]  Bus_wdata

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst,
(*mark_debug = "true"*)    output wire [31:0]  debug_wb_pc,
    output              debug_wb_ena,
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
);

    // TODO: 
    wire[1:0] ram_wdin_op_wire;
    wire[2:0] ram_rb_op_wire;
    wire ram_we_wire;
    wire pc_sel_wire;
    wire alua_sel_wire;
    wire alub_sel_wire;
    wire[3:0] alu_op_wire;
    wire[2:0] sext_op_wire;
    wire[1:0] rf_wsel_wire;
    wire rf_we_wire;
    wire[1:0] npc_op_wire;
    wire[31:0] inst_wire=inst;
    wire[31:0] ALUC_wire;
    wire[31:0] ext_wire;
    wire[31:0] rD1_wire;
    wire[31:0] rD2_wire;
    wire[31:0] rdo_wire;
    wire[31:0] pc4_wire;
    wire[31:0] pc_wire;
    wire[31:0] wD_wire;
    wire ALUf_wire;
    assign inst_addr=pc_wire[15:2];
    ifetch U_ifetch(
        .reset(cpu_rst),
        .clk(cpu_clk),
        .pc_sel(pc_sel_wire),
        .alu(ALUC_wire),
        .offset(ext_wire),
        .br(ALUf_wire),
        .npc_op(npc_op_wire),
        .pc4(pc4_wire),
        .pc(pc_wire)
    );
    control U_control(
        .opcode(inst_wire[6:0]),
        .funct3(inst_wire[14:12]),
        .funct7(inst_wire[31:25]),
        .ram_wdin_op(ram_wdin_op_wire),
        .ram_rb_op(ram_rb_op_wire),
        .ram_we(ram_we_wire),
        .pc_sel(pc_sel_wire),
        .alub_sel(alub_sel_wire),
        .alua_sel(alua_sel_wire),
        .alu_op(alu_op_wire),
        .sext_op(sext_op_wire),
        .rf_wsel(rf_wsel_wire),
        .rf_we(rf_we_wire),
        .npc_op(npc_op_wire)
    );
    execute U_execute(
        .pc(pc_wire),
        .rD1(rD1_wire),
        .ext(ext_wire),
        .rD2(rD2_wire),
        .alu_op(alu_op_wire),
        .alua_sel(alua_sel_wire),
        .alub_sel(alub_sel_wire),
        .C(ALUC_wire),
        .f(ALUf_wire)
    );
    memory U_memory(
        .ram_rb_op(ram_rb_op_wire),
        .ram_wdin_op(ram_wdin_op_wire),
        .ALUC(ALUC_wire),
        .ram_we(ram_we_wire),
        .din(rD2_wire),
        .clk(cpu_clk),
        .rdo(rdo_wire),
        .Bus_wdata(Bus_wdata),
        .Bus_addr(Bus_addr),
        .Bus_we(Bus_we),
        .Bus_rdata(Bus_rdata)
    );
    idecode U_idecode(
    .inst(inst_wire[31:7]),
    .sext_op(sext_op_wire),
    .rf_we(rf_we_wire),
    .rf_wsel(rf_wsel_wire),
    .clk(cpu_clk),
    .ALUC(ALUC_wire),
    .rdo(rdo_wire),
    .pc4(pc4_wire),
    .rD1(rD1_wire),
    .rD2(rD2_wire),
    .ext(ext_wire),
    .wD(wD_wire)
);
    //

`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = 1'b1;
    assign debug_wb_pc        = pc_wire;
    assign debug_wb_ena       = rf_we_wire;
    assign debug_wb_reg       = inst_wire[11:7];
    assign debug_wb_value     = wD_wire;
`endif

endmodule
