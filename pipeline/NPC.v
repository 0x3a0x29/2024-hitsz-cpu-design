`timescale 1ns / 1ps

module NPC(
    input wire[31:0] PC,
    input wire[31:0] offset,
    input wire br,
    input wire[1:0] op,
    input wire stop,
    input wire[31:0] ex_pc,
    output reg branch,
    output reg[31:0] npc,
    output wire[31:0] pc4 
    );
    parameter PC4=2'h0;
    parameter BEQ=2'h1;
    parameter JMP=2'h2;
    
    assign pc4=PC+3'd4;
    always@(*)begin
        if(~stop)begin
            case(op)
                PC4:begin npc=PC+3'd4; end
                BEQ:begin npc=br?ex_pc+offset:PC+3'd4; end
                JMP:begin npc=ex_pc+offset; end
                default:begin npc=PC+3'd4; end
            endcase
        end else begin
            npc=PC;
        end
    end
    always @(*)begin
        if(~stop)begin
            case(op)
                BEQ:begin branch=br?1'b1:PC+1'b0; end
                JMP:begin branch=1'b1; end
                default:begin branch=1'b0; end
            endcase
        end else begin
            branch=1'b0;
        end
    end
endmodule
