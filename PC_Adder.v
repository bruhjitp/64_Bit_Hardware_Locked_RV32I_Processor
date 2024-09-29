`timescale 1ns / 1ps
`include "Lock_Module.v"
module PC_Adder (a,b,c,key); //0111

    input [31:0]a,b;
    input [3:0]key;
    output [31:0]c;
    wire [31:0]sig_new;
    
    LOCK_MODULE #(.DATA_WIDTH(32), .KEY_WIDTH(4))
            d0(
        .data_in(a),
        .data_out(sig_new),
        .in_key(key)
        );
    defparam d0.KEY_4=4'b0111;
 
    assign c = sig_new + b;
    
endmodule