`timescale 1ns / 1ps
`include "ALU_Decoder.v"
`include "Main_Decoder.v"
`include "Lock_Module.v"

module Control_Unit_Top(Op,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,funct3,funct7,ALUControl,key);
    //key: (top)0101 11001100 - (main decoder)01010111 -(ALU Decoder)10101000
    input [6:0]Op,funct7;
    input [2:0]funct3;
    input [27:0]key;
    output RegWrite,ALUSrc,MemWrite,ResultSrc,Branch;
    output [1:0]ImmSrc;
    output [2:0]ALUControl;

    wire [1:0]ALUOp;
    wire [16:0]sig_new;
    LOCK_MODULE #(.DATA_WIDTH(14), .KEY_WIDTH(8))
            d0(
        .data_in({func7,Op}), //sig_new[13:7], sig_new[6:0]
        .data_out(sig_new[13:0]),
        .in_key(key[23:16])
        );
    LOCK_MODULE #(.DATA_WIDTH(3), .KEY_WIDTH(4))
            d1(
        .data_in(funct3),
        .data_out(sig_new[16:14]),
        .in_key(key[27:24])
        );
    defparam d0.KEY_8=8'b11001100;
    defparam d1.KEY_4=8'b0101;
    
    Main_Decoder Main_Decoder(
                .Op(sig_new[6:0]),
                .RegWrite(RegWrite),
                .ImmSrc(ImmSrc),
                .MemWrite(MemWrite),
                .ResultSrc(ResultSrc),
                .Branch(Branch),
                .ALUSrc(ALUSrc),
                .ALUOp(ALUOp),
                .key(key[15:8])
    );

    ALU_Decoder ALU_Decoder(
                            .ALUOp(ALUOp),
                            .funct3(sig_new[16:14]),
                            .funct7(sig_new[13:7]),
                            .op(sig_new[6:0]),
                            .ALUControl(ALUControl),
                            .key(key[7:0])
    );


endmodule