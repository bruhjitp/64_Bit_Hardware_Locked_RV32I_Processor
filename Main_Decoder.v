`timescale 1ns / 1ps
`include "Lock_Module.v"

module Main_Decoder(Op,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp,key); //01010111
    input [6:0]Op;
    input [7:0]key;
    output RegWrite,ALUSrc,MemWrite,ResultSrc,Branch;
    output [1:0]ImmSrc,ALUOp;
    
    wire [6:0]sig_new;
    LOCK_MODULE #(.DATA_WIDTH(7), .KEY_WIDTH(8))
            d0(
        .data_in(Op),
        .data_out(sig_new),
        .in_key(key)
        );
    defparam d0.KEY_8=8'b01010111;

    assign RegWrite = (sig_new == 7'b0000011 | sig_new == 7'b0110011) ? 1'b1 :
                                                                        1'b0 ;
    assign ImmSrc = (sig_new == 7'b0100011) ? 2'b01 : 
                    (sig_new == 7'b1100011) ? 2'b10 :    
                                            2'b00 ;
    assign ALUSrc = (sig_new == 7'b0000011 | sig_new == 7'b0100011) ? 1'b1 :
                                                                    1'b0 ;
    assign MemWrite = (sig_new == 7'b0100011) ? 1'b1 :
                                                1'b0 ;
    assign ResultSrc = (sig_new == 7'b0000011) ? 1'b1 :
                                                1'b0 ;
    assign Branch = (sig_new == 7'b1100011) ? 1'b1 :
                                            1'b0 ;
    assign ALUOp = (sig_new == 7'b0110011) ? 2'b10 :
                   (sig_new == 7'b1100011) ? 2'b01 :
                                             2'b00 ;

endmodule