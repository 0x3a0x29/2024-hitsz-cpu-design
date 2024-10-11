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
    
    wire[31:0] if_inst_wire=inst;
    wire[31:0] id_inst_wire;
    
    
    wire[31:0] rb_wire;
    wire[31:0] if_pc4_wire;
    wire[31:0] id_pc4_wire;
    wire[31:0] if_pc_wire;
    wire[31:0] id_pc_wire;
    wire[31:0] wb_wD_wire;
    
    wire[31:0] id_rD1_wire;
    wire[31:0] id_rD2_wire;
    wire[31:0] ex_rD1_wire;
    wire[31:0] ex_rD2_wire;
    wire[31:0] ex_pc_wire;
    wire[1:0] id_rf_wsel_wire;
    wire[1:0] ex_rf_wsel_wire;
    wire id_rf_we_wire;
    wire ex_rf_we_wire;
    wire id_pc_sel_wire;
    wire ex_pc_sel_wire;
    wire[1:0] id_ram_wdin_op_wire;
    wire[2:0] id_ram_rb_op_wire;
    wire[1:0] ex_ram_wdin_op_wire;
    wire[2:0] ex_ram_rb_op_wire;
    wire id_ram_we_wire;
    wire ex_ram_we_wire;
    wire[1:0] id_npc_op_wire;
    wire[1:0] ex_npc_op_wire;
    wire[31:0] id_ext_wire;
    wire[31:0] ex_ext_wire;
    wire[2:0] sext_op_wire;
    wire[31:0] ex_pc4_wire;
    wire[3:0] id_alu_op_wire;
    wire[3:0] ex_alu_op_wire;
    wire[4:0] ex_wR_wire;
    wire id_alua_sel_wire;
    wire id_alub_sel_wire;
    wire ex_alua_sel_wire;
    wire ex_alub_sel_wire;
    
    wire[31:0] ex_C_wire;
    wire[31:0] mem_C_wire;
    wire ex_f_wire;
    wire[31:0] mem_pc4_wire;
    wire[31:0] ex_ext_wire;
    wire[31:0] mem_ext_wire;
    wire[1:0] mem_ram_wdin_op_wire;
    wire[2:0] mem_ram_rb_op_wire;
    wire mem_ram_we_wire;
    wire mem_rf_we_wire;
    wire[1:0] mem_rf_wsel_wire;
    wire[31:0] mem_rD2_wire;
    wire[4:0] mem_wR_wire;
    wire[31:0] mem_rdo_wire;
    wire[31:0] mem_pc_wire;
    
    wire[31:0] wb_rdo_wire;
    wire wb_rf_we_wire;
    wire[1:0] wb_rf_wsel_wire;
    wire[31:0] wb_C_wire;
    wire[4:0] wb_wR_wire;
    wire[31:0] wb_pc4_wire;
    wire[31:0] wb_ext_wire;
    wire[31:0] wb_pc_wire;
    
    wire rs1_hazard_wire;
    wire rs2_hazard_wire;
    wire[31:0] hazard_rD1_wire;
    wire[31:0] hazard_rD2_wire;
    
    wire stop_wire;
    wire branch_wire;
    wire clear_wire;
    assign clear_wire=branch_wire|ex_pc_sel_wire;
    assign inst_addr=if_pc_wire[15:2];
    ifetch U_ifetch(
        .reset(cpu_rst),
        .clk(cpu_clk),
        .pc_sel(ex_pc_sel_wire),
        .alu(ex_C_wire),
        .offset(ex_ext_wire),
        .br(ex_f_wire),
        .npc_op(ex_npc_op_wire),
        .pc4(if_pc4_wire),
        .pc(if_pc_wire),
        .stop(stop_wire),
        .ex_pc(ex_pc_wire),
        .branch(branch_wire)
    );
    reg_IF_ID U_IF_ID(
        .rst(cpu_rst),
        .clk(cpu_clk),
        .if_pc(if_pc_wire),
        .if_pc4(if_pc4_wire),
        .if_inst(if_inst_wire),
        .id_pc(id_pc_wire),
        .id_pc4(id_pc4_wire),
        .id_inst(id_inst_wire),
        .stop(stop_wire),
        .clear(clear_wire)
    );
    
    idecode U_idecode(
        .inst(id_inst_wire[31:7]),
        .sext_op(sext_op_wire),
        .rf_we(wb_rf_we_wire),
        .rf_wsel(wb_rf_wsel_wire),
        .clk(cpu_clk),
        .ALUC(wb_C_wire),
        .rdo(wb_rdo_wire),
        .pc4(wb_pc4_wire),
        .rD1(id_rD1_wire),
        .rD2(id_rD2_wire),
        .id_ext(id_ext_wire),
        .wb_ext(wb_ext_wire),
        .wR(wb_wR_wire),
        .wD(wb_wD_wire)
    );
    control U_control(
        .opcode(id_inst_wire[6:0]),
        .funct3(id_inst_wire[14:12]),
        .funct7(id_inst_wire[31:25]),
        .ram_wdin_op(id_ram_wdin_op_wire),
        .ram_rb_op(id_ram_rb_op_wire),
        .ram_we(id_ram_we_wire),
        .pc_sel(id_pc_sel_wire),
        .alub_sel(id_alub_sel_wire),
        .alua_sel(id_alua_sel_wire),
        .alu_op(id_alu_op_wire),
        .sext_op(sext_op_wire),
        .rf_wsel(id_rf_wsel_wire),
        .rf_we(id_rf_we_wire),
        .npc_op(id_npc_op_wire)
    );
    reg_ID_EX U_ID_EX(
        .clk(cpu_clk),
        .rst(cpu_rst),
        .clear(stop_wire|clear_wire),
        .id_rD1(id_rD1_wire),
        .id_rD2(id_rD2_wire),
        .id_pc(id_pc_wire),
        .id_rf_we(id_rf_we_wire),
        .id_rf_wsel(id_rf_wsel_wire),
        .id_pc_sel(id_pc_sel_wire),
        .id_ext(id_ext_wire),
        .id_ram_wdin_op(id_ram_wdin_op_wire),
        .id_ram_rb_op(id_ram_rb_op_wire),
        .id_ram_we(id_ram_we_wire),
        .id_npc_op(id_npc_op_wire),
        .id_pc4(id_pc4_wire),
        .id_alu_op(id_alu_op_wire),
        .id_wR(id_inst_wire[11:7]),
        .id_alub_sel(id_alub_sel_wire),
        .id_alua_sel(id_alua_sel_wire),
        .ex_ram_we(ex_ram_we_wire),
        .ex_npc_op(ex_npc_op_wire),
        .ex_pc4(ex_pc4_wire),
        .ex_alu_op(ex_alu_op_wire),
        .ex_wR(ex_wR_wire),
        .ex_alub_sel(ex_alub_sel_wire),
        .ex_alua_sel(ex_alua_sel_wire),
        .ex_ext(ex_ext_wire),
        .ex_rD1(ex_rD1_wire),
        .ex_rD2(ex_rD2_wire),
        .ex_pc(ex_pc_wire),
        .ex_rf_we(ex_rf_we_wire),
        .ex_pc_sel(ex_pc_sel_wire),
        .ex_rf_wsel(ex_rf_wsel_wire),
        .ex_ram_wdin_op(ex_ram_wdin_op_wire),
        .ex_ram_rb_op(ex_ram_rb_op_wire),
        .rs1_hazard(rs1_hazard_wire),
        .rs2_hazard(rs2_hazard_wire),
        .hazard_rD1(hazard_rD1_wire),
        .hazard_rD2(hazard_rD2_wire)
    );
    
    execute U_execute(
        .pc(ex_pc_wire),
        .rD1(ex_rD1_wire),
        .ext(ex_ext_wire),
        .rD2(ex_rD2_wire),
        .alu_op(ex_alu_op_wire),
        .alua_sel(ex_alua_sel_wire),
        .alub_sel(ex_alub_sel_wire),
        .C(ex_C_wire),
        .f(ex_f_wire)
    );
    reg_EX_MEM U_EX_MEM(
        .clk(cpu_clk),
        .rst(cpu_rst),
        .ex_C(ex_C_wire),
        .mem_C(mem_C_wire),
        .ex_pc4(ex_pc4_wire),
        .mem_pc4(mem_pc4_wire),
        .ex_ext(ex_ext_wire),
        .mem_ext(mem_ext_wire),
        .ex_ram_wdin_op(ex_ram_wdin_op_wire),
        .mem_ram_wdin_op(mem_ram_wdin_op_wire),
        .ex_ram_rb_op(ex_ram_rb_op_wire),
        .mem_ram_rb_op(mem_ram_rb_op_wire),
        .ex_ram_we(ex_ram_we_wire),
        .mem_ram_we(mem_ram_we_wire),
        .ex_rf_we(ex_rf_we_wire),
        .mem_rf_we(mem_rf_we_wire),
        .ex_rf_wsel(ex_rf_wsel_wire),
        .mem_rf_wsel(mem_rf_wsel_wire),
        .ex_rD2(ex_rD2_wire),
        .mem_rD2(mem_rD2_wire),
        .ex_wR(ex_wR_wire),
        .mem_wR(mem_wR_wire),
        .ex_pc(ex_pc_wire),
        .mem_pc(mem_pc_wire)
    );
    
    memory U_memory(
        .ram_rb_op(mem_ram_rb_op_wire),
        .ram_wdin_op(mem_ram_wdin_op_wire),
        .ALUC(mem_C_wire),
        .ram_we(mem_ram_we_wire),
        .din(mem_rD2_wire),
        .clk(cpu_clk),
        .rdo(mem_rdo_wire),
        .Bus_wdata(Bus_wdata),
        .Bus_addr(Bus_addr),
        .Bus_we(Bus_we),
        .Bus_rdata(Bus_rdata)
    );
    reg_MEM_WB U_MEM_WB(
        .clk(cpu_clk),
        .rst(cpu_rst),
        .mem_rdo(mem_rdo_wire),
        .wb_rdo(wb_rdo_wire),
        .mem_rf_we(mem_rf_we_wire),
        .wb_rf_we(wb_rf_we_wire),
        .mem_C(mem_C_wire),
        .wb_C(wb_C_wire),
        .mem_wR(mem_wR_wire),
        .wb_wR(wb_wR_wire),
        .mem_pc4(mem_pc4_wire),
        .wb_pc4(wb_pc4_wire),
        .mem_ext(mem_ext_wire),
        .wb_ext(wb_ext_wire),
        .mem_rf_wsel(mem_rf_wsel_wire),
        .wb_rf_wsel(wb_rf_wsel_wire),
        .mem_pc(mem_pc_wire),
        .wb_pc(wb_pc_wire)
    );
    wire[4:0] id_rR1_wire=id_inst_wire[19:15];
    hazard U_hazard(
        .id_rR1(id_inst_wire[19:15]),
        .id_rR2(id_inst_wire[24:20]),
        .ex_wR(ex_wR_wire),
        .ex_rf_we(ex_rf_we_wire),
        .ex_rf_wsel(ex_rf_wsel_wire),
        .ex_C(ex_C_wire),
        .ex_ext(ex_ext_wire),
        .ex_pc4(ex_pc4_wire),
        .mem_wR(mem_wR_wire),
        .mem_rf_we(mem_rf_we_wire),
        .mem_rf_wsel(mem_rf_wsel_wire),
        .mem_C(mem_C_wire),
        .mem_ext(mem_ext_wire),
        .mem_pc4(mem_pc4_wire),
        .mem_rdo(mem_rdo_wire),
        .wb_wR(wb_wR_wire),
        .wb_rf_we(wb_rf_we_wire),
        .wb_rf_wsel(wb_rf_wsel_wire),
        .wb_C(wb_C_wire),
        .wb_ext(wb_ext_wire),
        .wb_pc4(wb_pc4_wire),
        .wb_rdo(wb_rdo_wire),
        .rs1_hazard(rs1_hazard_wire),
        .rs2_hazard(rs2_hazard_wire),
        .hazard_rD1(hazard_rD1_wire),
        .hazard_rD2(hazard_rD2_wire),
        .stop(stop_wire)
    );
    //

`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = (wb_rf_we_wire)|(|wb_pc_wire);
    assign debug_wb_pc        = wb_pc_wire;
    assign debug_wb_ena       = wb_rf_we_wire;
    assign debug_wb_reg       = wb_wR_wire;
    assign debug_wb_value     = wb_wD_wire;
`endif

endmodule