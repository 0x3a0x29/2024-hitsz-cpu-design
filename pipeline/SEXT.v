`timescale 1ns / 1ps

module SEXT(
    input wire[2:0] op,
    input wire[31:7] din,
    output reg[31:0] ext
    );
    parameter SEXT_I=3'h0;
    parameter SEXT_S=3'h1;
    parameter SEXT_B=3'h2;
    parameter SEXT_U=3'h3;
    parameter SEXT_J=3'h4;
    always@(*)begin
        case(op)
            SEXT_I:begin ext={{20{din[31]}},din[31:20]};end
            SEXT_S:begin ext={{20{din[31]}},din[31:25],din[11:7]};end
            SEXT_B:begin ext={{19{din[31]}},din[31],din[7],din[30:25],din[11:8],1'b0};end
            SEXT_U:begin ext={din[31:12],12'h000};end
            SEXT_J:begin ext={{11{din[31]}},din[31],din[19:12],din[20],din[30:21],1'b0};end
            default:begin ext=32'h0;end
        endcase
    end
endmodule
