`timescale 1ns / 1ps

module memory(
    input wire[2:0] ram_rb_op,
    input wire[1:0] ram_wdin_op,
    input wire [31:0] ALUC,
    input wire ram_we,
    input wire [31:0] din,
    input wire clk,
    output reg[31:0] rdo,
    output wire Bus_we,
    output wire[31:0] Bus_addr,
    output reg[31:0] Bus_wdata,
    input wire[31:0] Bus_rdata
    );
    assign Bus_addr=ALUC;
    assign Bus_we=ram_we;
    
    parameter WRAM_SB=2'h0;
    parameter WRAM_SH=2'h1;
    parameter WRAM_SW=2'h2;
    parameter RDO_LB=3'h0;
    parameter RDO_LBU=3'h1;
    parameter RDO_LH=3'h2;
    parameter RDO_LHU=3'h3;
    parameter RDO_LW=3'h4;
    always @(*) begin
        case (ram_wdin_op)
            WRAM_SW: Bus_wdata = din;
            WRAM_SB:begin 
                case(ALUC[1:0])
                   2'h0:Bus_wdata = {Bus_rdata[31:8],din[7:0]};
                   2'h1:Bus_wdata = {Bus_rdata[31:16],din[7:0],Bus_rdata[7:0]};
                   2'h2:Bus_wdata = {Bus_rdata[31:24],din[7:0],Bus_rdata[15:0]};
                   default:Bus_wdata = {din[7:0],Bus_rdata[23:0]};
                endcase
            end
            WRAM_SH:begin 
                case(ALUC[1])
                   1'h0:Bus_wdata = {Bus_rdata[31:16],din[15:0]};
                   default:Bus_wdata = {din[15:0],Bus_rdata[15:0]};
                endcase
            end
            default: Bus_wdata = din;
        endcase
    end
    always @(*) begin
        case (ram_rb_op)
            RDO_LW:  rdo = Bus_rdata;
            RDO_LB:begin
                case(ALUC[1:0])
                    2'h0: rdo={{24{Bus_rdata[7]}},Bus_rdata[7:0]};
                    2'h1: rdo={{24{Bus_rdata[15]}},Bus_rdata[15:8]};
                    2'h2: rdo={{24{Bus_rdata[23]}},Bus_rdata[23:16]};
                    default: rdo={{24{Bus_rdata[31]}},Bus_rdata[31:24]};
                endcase
            end  
            RDO_LBU:begin
                case(ALUC[1:0])
                    2'h0: rdo={24'd0,Bus_rdata[7:0]};
                    2'h1: rdo={24'd0,Bus_rdata[15:8]};
                    2'h2: rdo={24'd0,Bus_rdata[23:16]};
                    default: rdo={24'd0,Bus_rdata[31:24]};
                endcase
            end  
            RDO_LH:begin
                case(ALUC[1])
                    1'b0: rdo={{16{Bus_rdata[15]}},Bus_rdata[15:0]};
                    default: rdo={{16{Bus_rdata[31]}},Bus_rdata[31:16]};
                endcase
            end
            RDO_LHU:begin
                case(ALUC[1])
                    1'b0: rdo={16'd0,Bus_rdata[15:0]};
                    default: rdo={16'd0,Bus_rdata[31:16]};
                endcase
            end
            default: rdo = Bus_rdata;
        endcase
    end
endmodule
