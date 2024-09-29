`timescale 1ns / 1ps
`include "PC.v"
`include "Instruction_Memory.v"
`include "Register_File.v"
`include "Sign_Extend.v"
`include "ALU.v"
`include "Control_Unit_Top.v"
`include "Data_Memory.v"
`include "PC_Adder.v"
`include "Mux.v"
`include "Lock_Module.v"

module Single_Cycle_Top(clk,rst,key);

    input clk,rst;
    input [63:0] key;

    wire [31:0] PC_Top,RD_Instr,RD1_Top,Imm_Ext_Top,ALUResult,ReadData,PCPlus4,RD2_Top,SrcB,Result;
    wire RegWrite,MemWrite,ALUSrc,ResultSrc;
    wire [1:0]ImmSrc;
    wire [2:0]ALUControl_Top;
    

    PC_Module PC(
        .clk(clk),
        .rst(rst),
        .PC(PC_Top),
        .PC_Next(PCPlus4),
        .key(key[63:56])
    );

    PC_Adder PC_Adder(
                    .a(PC_Top),
                    .b(32'd4),
                    .c(PCPlus4),
                    .key(key[23:16])
    );
    
    Instruction_Memory Instruction_Memory(
                            .rst(rst),
                            .A(PC_Top),
                            .RD(RD_Instr),
                            .key(key[55:48])
    );

    Register_File Register_File(
                            .clk(clk),
                            .rst(rst),
                            .WE3(RegWrite),
                            .WD3(Result),
                            .A1(RD_Instr[19:15]),
                            .A2(RD_Instr[24:20]),
                            .A3(RD_Instr[11:7]),
                            .RD1(RD1_Top),
                            .RD2(RD2_Top)
    );

    Sign_Extend Sign_Extend(
                        .In(RD_Instr),
                        .ImmSrc(ImmSrc[0]),
                        .Imm_Ext(Imm_Ext_Top)
    );

    Mux Mux_Register_to_ALU(
                            .a(RD2_Top),
                            .b(Imm_Ext_Top),
                            .s(ALUSrc),
                            .c(SrcB)
    );

    ALU ALU(
            .A(RD1_Top),
            .B(SrcB),
            .Result(ALUResult),
            .ALUControl(ALUControl_Top),
            .OverFlow(),
            .Carry(),
            .Zero(),
            .Negative(),
            .key(key[15:8])
    );

    Control_Unit_Top Control_Unit_Top(
                            .Op(RD_Instr[6:0]),
                            .RegWrite(RegWrite),
                            .ImmSrc(ImmSrc),
                            .ALUSrc(ALUSrc),
                            .MemWrite(MemWrite),
                            .ResultSrc(ResultSrc),
                            .Branch(),
                            .funct3(RD_Instr[14:12]),
                            .funct7(RD_Instr[6:0]),
                            .ALUControl(ALUControl_Top),
                            .key(key[47:24])
    );

    Data_Memory Data_Memory(
                        .clk(clk),
                        .rst(rst),
                        .WE(MemWrite),
                        .WD(RD2_Top),
                        .A(ALUResult),
                        .RD(ReadData),
                        .key(key[7:0])
    );

    Mux Mux_DataMemory_to_Register(
                            .a(ALUResult),
                            .b(ReadData),
                            .s(ResultSrc),
                            .c(Result)
    );

endmodule