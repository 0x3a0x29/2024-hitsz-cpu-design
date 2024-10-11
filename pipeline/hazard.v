`timescale 1ns / 1ps

module hazard(
    input wire[4:0] id_rR1,
    input wire[4:0] id_rR2,
    input wire[4:0] ex_wR,
    input wire ex_rf_we,
    input wire[1:0] ex_rf_wsel,
    input wire[31:0] ex_C,
    input wire[31:0] ex_ext,
    input wire[31:0] ex_pc4,
    input wire[4:0] mem_wR,
    input wire mem_rf_we,
    input wire[1:0] mem_rf_wsel,
    input wire[31:0] mem_C,
    input wire[31:0] mem_ext,
    input wire[31:0] mem_pc4,
    input wire[31:0] mem_rdo,
    input wire[4:0] wb_wR,
    input wire wb_rf_we,
    input wire[1:0] wb_rf_wsel,
    input wire[31:0] wb_C,
    input wire[31:0] wb_ext,
    input wire[31:0] wb_pc4,
    input wire[31:0] wb_rdo,
    output wire stop,
    output wire rs1_hazard,
    output wire rs2_hazard,
    output reg[31:0] hazard_rD1,
    output reg[31:0] hazard_rD2
    );
    parameter WD_ALUC=2'h0;
    parameter WD_RAM=2'h1;
    parameter WD_EXT=2'h2;
    parameter WD_PC4=2'h3;
    wire rs1_ID_EX_hazard  = ex_rf_we  & ( |ex_wR  ) & ( id_rR1 == ex_wR  );
    wire rs2_ID_EX_hazard  = ex_rf_we  & ( |ex_wR  ) & ( id_rR2 == ex_wR  );
    wire rs1_ID_MEM_hazard = mem_rf_we & ( |mem_wR ) & ( id_rR1 == mem_wR );
    wire rs2_ID_MEM_hazard = mem_rf_we & ( |mem_wR ) & ( id_rR2 == mem_wR );
    wire rs1_ID_WB_hazard  = wb_rf_we  & ( |wb_wR  ) & ( id_rR1 == wb_wR  );
    wire rs2_ID_WB_hazard  = wb_rf_we  & ( |wb_wR  ) & ( id_rR2 == wb_wR  );
    assign stop = ( rs1_ID_EX_hazard | rs2_ID_EX_hazard ) & ( ex_rf_wsel == WD_RAM );
    assign rs1_hazard = ( rs1_ID_EX_hazard | rs1_ID_MEM_hazard | rs1_ID_WB_hazard ) & ~stop;
    assign rs2_hazard = ( rs2_ID_EX_hazard | rs2_ID_MEM_hazard | rs2_ID_WB_hazard ) & ~stop;
    always@(*)begin
        case(1'b1)
            rs1_ID_EX_hazard:begin
                case(ex_rf_wsel)
                    WD_ALUC:begin
                        hazard_rD1=ex_C;
                    end
                    WD_EXT:begin
                        hazard_rD1=ex_ext;
                    end
                    WD_PC4:begin
                        hazard_rD1=ex_pc4;
                    end
                    default:begin
                        hazard_rD1=32'h0;
                    end
                endcase
            end
            rs1_ID_MEM_hazard:begin
                case(mem_rf_wsel)
                    WD_ALUC:begin
                        hazard_rD1=mem_C;
                    end
                    WD_RAM:begin
                        hazard_rD1=mem_rdo;
                    end
                    WD_EXT:begin
                        hazard_rD1=mem_ext;
                    end
                    WD_PC4:begin
                        hazard_rD1=mem_pc4;
                    end
                    default:begin
                        hazard_rD1=32'h0;
                    end
                endcase
            end
            rs1_ID_WB_hazard:begin
                case(wb_rf_wsel)
                    WD_ALUC:begin
                        hazard_rD1=wb_C;
                    end
                    WD_RAM:begin
                        hazard_rD1=wb_rdo;
                    end
                    WD_EXT:begin
                        hazard_rD1=wb_ext;
                    end
                    WD_PC4:begin
                        hazard_rD1=wb_pc4;
                    end
                    default:begin
                        hazard_rD1=32'h0;
                    end
                endcase
            end
            default:hazard_rD1=32'h0;
        endcase
    end
    always@(*)begin
        case(1'b1)
            rs2_ID_EX_hazard:begin
                case(ex_rf_wsel)
                    WD_ALUC:begin
                        hazard_rD2=ex_C;
                    end
                    WD_EXT:begin
                        hazard_rD2=ex_ext;
                    end
                    WD_PC4:begin
                        hazard_rD2=ex_pc4;
                    end
                    default:begin
                        hazard_rD2=32'h0;
                    end
                endcase
            end
            rs2_ID_MEM_hazard:begin
                case(mem_rf_wsel)
                    WD_ALUC:begin
                        hazard_rD2=mem_C;
                    end
                    WD_RAM:begin
                        hazard_rD2=mem_rdo;
                    end
                    WD_EXT:begin
                        hazard_rD2=mem_ext;
                    end
                    WD_PC4:begin
                        hazard_rD2=mem_pc4;
                    end
                    default:begin
                        hazard_rD2=32'h0;
                    end
                endcase
            end
            rs2_ID_WB_hazard:begin
                case(wb_rf_wsel)
                    WD_ALUC:begin
                        hazard_rD2=wb_C;
                    end
                    WD_RAM:begin
                        hazard_rD2=wb_rdo;
                    end
                    WD_EXT:begin
                        hazard_rD2=wb_ext;
                    end
                    WD_PC4:begin
                        hazard_rD2=wb_pc4;
                    end
                    default:begin
                        hazard_rD2=32'h0;
                    end
                endcase
            end
            default:hazard_rD2=32'h0;
        endcase
    end
endmodule
