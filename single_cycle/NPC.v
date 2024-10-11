`timescale 1ns / 1ps

module NPC(
    input wire[31:0] PC,
    input wire[31:0] offset,
    input wire br,
    input wire[1:0] op,
    output reg[31:0] npc,
    output wire[31:0] pc4 
    );
    parameter PC4=2'h0;
    parameter BEQ=2'h1;
    parameter JMP=2'h2;
    
    assign pc4=PC+3'd4;
    always@(*)begin
        case(op)
            PC4:begin npc=PC+3'd4; end
            BEQ:begin npc=br?PC+offset:PC+3'd4; end
            JMP:begin npc=PC+offset; end
            default:begin npc=PC+3'd4; end
        endcase
    end
endmodule
