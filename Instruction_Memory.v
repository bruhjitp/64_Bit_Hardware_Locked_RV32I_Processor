`timescale 1ns / 1ps
`include "Lock_Module.v"
module Instruction_Memory(rst,A,RD,key); //1010 0101

  input rst;
  input [31:0]A;
  input [7:0]key;
  output [31:0]RD;

  reg [31:0] mem [1023:0];
  wire [32:0]sig_new;
  
  LOCK_MODULE #(.DATA_WIDTH(32), .KEY_WIDTH(2))
            d0(
        .data_in(sig_new[31:0]),
        .data_out(RD),
        .in_key(key[3:0])
        );
        
   LOCK_MODULE #(.DATA_WIDTH(32), .KEY_WIDTH(2))
            d1(
        .data_in(rst),
        .data_out(sig_new[32]),
        .in_key(key[7:4])
        );
  defparam d0.KEY_4=4'b1010;
  defparam d1.KEY_4=4'b0101;
  assign sig_new[31:0] = (~sig_new[32]) ? {32{1'b0}} : mem[A[31:2]];

  initial begin
    $readmemh("memfile.txt",mem);
  end


/*
  initial begin
    //mem[0] = 32'hFFC4A303;
    //mem[1] = 32'h00832383;
    // mem[0] = 32'h0064A423;
    // mem[1] = 32'h00B62423;
    mem[0] = 32'h0062E233;
    // mem[1] = 32'h00B62423;

  end
*/
endmodule