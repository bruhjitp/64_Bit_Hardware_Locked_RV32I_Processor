`timescale 1ns / 1ps
`include "Lock_Module.v"
module Data_Memory(clk,rst,WE,WD,A,RD,key); //0000 11 11

    input clk,rst,WE;
    input [31:0]A,WD;
    input [7:0]key;
    output [31:0]RD;

    reg [31:0] mem [1023:0];
    wire[66:0]sig_new;
    
    LOCK_MODULE #(.DATA_WIDTH(32), .KEY_WIDTH(2))
            d0(
        .data_in(A),
        .data_out(sig_new[31:0]),
        .in_key(key[1:0])
        );
    LOCK_MODULE #(.DATA_WIDTH(32), .KEY_WIDTH(2))
            d1(
        .data_in(WD),
        .data_out(sig_new[63:32]),
        .in_key(key[3:2])
        );
    LOCK_MODULE #(.DATA_WIDTH(3), .KEY_WIDTH(2))
            d2(
        .data_in({clk,rst,WE}),
        .data_out(sig_new[66:64]),
        .in_key(key[1:0])
        );
    
    defparam d0.KEY_2=2'b11;
    defparam d1.KEY_2=2'b11;
    defparam d2.KEY_4=4'b0000;
    
    always @ (posedge sig_new[66])
    begin
        if(sig_new[64])
            mem[sig_new[31:0]] <= sig_new[63:32];
    end

    assign RD = (~sig_new[65]) ? 32'd0 : mem[sig_new[31:0]];

    initial begin
        mem[28] = 32'h00000020;
        //mem[40] = 32'h00000002;
    end


endmodule