`timescale 1ns / 1ps

module ALU(
    input wire[31:0] A,
    input wire[31:0] B,
    input wire[3:0] op,
    output wire f,
    output wire[31:0] C
    );
    
    reg[31:0] resultC;
    reg resultf;
    
    assign C=resultC;
    assign f=resultf;
    
    parameter ADD=4'h0;
    parameter SUB=4'h1;
    parameter AND=4'h2;
    parameter OR=4'h3;
    parameter XOR=4'h4;
    parameter SLL=4'h5;
    parameter SRL=4'h6;
    parameter SRA=4'h7;
    parameter EQ=4'h8;
    parameter NE=4'h9;
    parameter LT=4'ha;
    parameter GE=4'hb;
    parameter LTU=4'hc;
    parameter GEU=4'hd;
    
    always @(*)begin
        case(op)
            ADD:begin
                resultC=A+B;
                resultf=1'b0;
            end
            SUB:begin
                resultC=A-B;
                resultf=1'b0;
            end
            AND:begin
                resultC=A&B;
                resultf=1'b0;
            end
            OR:begin
                resultC=A|B;
                resultf=1'b0;
            end
            XOR:begin
                resultC=A^B;
                resultf=1'b0;
            end
            SLL:begin
                resultC=A<<B[4:0];
                resultf=1'b0;
            end
            SRL:begin
                resultC=A>>B[4:0];
                resultf=1'b0;
            end
            SRA:begin
                resultC=$signed(A)>>>B[4:0];
                resultf=1'b0;
            end
            EQ:begin
                resultC=32'h0;
                resultf=(A==B);
            end
            NE:begin
                resultC=32'h0;
                resultf=(A!=B);
            end
            LT:begin
                resultC=($signed(A)<$signed(B));
                resultf=($signed(A)<$signed(B));
            end
            GE:begin
                resultC=($signed(A)>=$signed(B));
                resultf=($signed(A)>=$signed(B));
            end
            LTU:begin
                resultC=(A<B);
                resultf=(A<B);
            end
            GEU:begin
                resultC=(A>=B);
                resultf=(A>=B);
            end
            default:begin
                resultC=32'h0;
                resultf=1'b0;
            end
        endcase
    end
endmodule
