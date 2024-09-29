`timescale 1ns / 1ps
`include "Lock_Module.v"
module ALU_Decoder(ALUOp,funct3,funct7,op,ALUControl,key); //10101000

    input [1:0]ALUOp;
    input [2:0]funct3;
    input [6:0]funct7,op;
    input [7:0]key;
    output [2:0]ALUControl;
    
    wire [18:0]sig_new;
    
    LOCK_MODULE #(.DATA_WIDTH(19), .KEY_WIDTH(8))
            d0(
        .data_in({ALUOp,funct3,func7,op}), //sig_new[18:17], sig_new[16:14], sig_new[13:7]-func7[5]==sig_new[11], sig_new[6:0]-op[5]==sig_new[5]
        .data_out(sig_new),
        .in_key(key)
        );
    defparam d0.KEY_8=8'b10101000;
    // Method 1 
    // assign ALUControl = (ALUOp == 2'b00) ? 3'b000 :
    //                     (ALUOp == 2'b01) ? 3'b001 :
    //                     (ALUOp == 2'b10) ? ((funct3 == 3'b000) ? ((({op[5],funct7[5]} == 2'b00) | ({op[5],funct7[5]} == 2'b01) | ({op[5],funct7[5]} == 2'b10)) ? 3'b000 : 3'b001) : 
    //                                         (funct3 == 3'b010) ? 3'b101 : 
    //                                         (funct3 == 3'b110) ? 3'b011 : 
    //                                         (funct3 == 3'b111) ? 3'b010 : 3'b000) :
    //                                        3'b000;

    // Method 2
    assign ALUControl = (sig_new[18:17] == 2'b00) ? 3'b000 :
                        (sig_new[18:17] == 2'b01) ? 3'b001 :
                        ((sig_new[18:17] == 2'b10) & (sig_new[16:14] == 3'b000) & ({sig_new[5],sig_new[11]} == 2'b11)) ? 3'b001 : 
                        ((sig_new[18:17] == 2'b10) & (sig_new[16:14] == 3'b000) & ({sig_new[5],sig_new[11]} != 2'b11)) ? 3'b000 : 
                        ((sig_new[18:17] == 2'b10) & (sig_new[16:14] == 3'b010)) ? 3'b101 : 
                        ((sig_new[18:17] == 2'b10) & (sig_new[16:14] == 3'b110)) ? 3'b011 : 
                        ((sig_new[18:17] == 2'b10) & (sig_new[16:14] == 3'b111)) ? 3'b010 : 
                                                                  3'b000 ;
endmodule