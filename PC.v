`timescale 1ns / 1ps
`include "Lock_Module.v"
module PC_Module(clk,rst,PC,PC_Next,key); //1010 00 11
    input clk,rst;
    input [31:0]PC_Next;
    input [7:0]key;
    output [31:0]PC;
    reg [31:0]PC;
    wire [33:0]sig_new;
    
    LOCK_MODULE #(.DATA_WIDTH(1), .KEY_WIDTH(2))
            d0(
        .data_in(clk),
        .data_out(sig_new[0]),
        .in_key(key[1:0])
        );
    LOCK_MODULE #(.DATA_WIDTH(1), .KEY_WIDTH(2))
            d1(
        .data_in(rst),
        .data_out(sig_new[1]),
        .in_key(key[3:2])
        );
    LOCK_MODULE #(.DATA_WIDTH(32), .KEY_WIDTH(4))
            d2(
        .data_in(PC_Next),
        .data_out(sig_new[33:2]),
        .in_key(key[7:4])
        );
 defparam d0.KEY_2=2'b11;
 defparam d1.KEY_2=2'b00;
 defparam d2.KEY_4=4'b1010;
 
    always @(posedge sig_new[0])
    begin
        if(~sig_new[1])
            PC <= {32{1'b0}};
        else
            PC <= sig_new[33:2];
    end
endmodule