`timescale 1ns / 1ps
`include "Lock_Module.v"
module ALU(A,B,Result,ALUControl,OverFlow,Carry,Zero,Negative,key); //0000 11 11

    input [31:0]A,B;
    input [2:0]ALUControl;
    input [7:0]key;
    output Carry,OverFlow,Zero,Negative;
    output [31:0]Result;

    wire Cout;
    wire [31:0]Sum;
    wire [66:0]sig_new;
    
    LOCK_MODULE #(.DATA_WIDTH(32), .KEY_WIDTH(2))
            d0(
        .data_in(A),
        .data_out(sig_new[31:0]),
        .in_key(key[1:0])
        );
    LOCK_MODULE #(.DATA_WIDTH(32), .KEY_WIDTH(2))
            d1(
        .data_in(B),
        .data_out(sig_new[63:32]),
        .in_key(key[3:2])
        );
    LOCK_MODULE #(.DATA_WIDTH(3), .KEY_WIDTH(4))
            d2(
        .data_in(ALUControl),
        .data_out(sig_new[66:64]),
        .in_key(key[7:4])
        );
    defparam d0.KEY_2=2'b11;
    defparam d1.KEY_2=2'b11;
    defparam d2.KEY_4=4'b0000;
 
    assign {Cout,Sum} = (ALUControl[0] == 1'b0) ? A + B :
                                          (A + ((~B)+1)) ;
    assign Result = (ALUControl == 3'b000) ? Sum :
                    (ALUControl == 3'b001) ? Sum :
                    (ALUControl == 3'b010) ? A & B :
                    (ALUControl == 3'b011) ? A | B :
                    (ALUControl == 3'b101) ? {{31{1'b0}},(Sum[31])} : {32{1'b0}};
    
    assign OverFlow = ((Sum[31] ^ A[31]) & 
                      (~(ALUControl[0] ^ B[31] ^ A[31])) &
                      (~ALUControl[1]));
    assign Carry = ((~ALUControl[1]) & Cout);
    assign Zero = &(~Result);
    assign Negative = Result[31];

endmodule