`timescale 1ns / 1ps
/*
in top module overwrite DATA_WIDTH and KEY_WIDTH using parameter mapping
in top module overwrite KEY value of the width using defparam

LOCK_MODULE #(.DATA_WIDTH(), .KEY_WIDTH())
            d0(
        .data_in(),
        .data_out(),
        .in_key()
        );
 defparam d0.KEY_n=; //overriding the key value corresponding to this instantiation
*/
module LOCK_MODULE #(parameter DATA_WIDTH=32, KEY_WIDTH=16)(data_in, , data_out, in_key);

    parameter KEY_1=1'b1;
    parameter KEY_2=2'b01;
    parameter KEY_4=4'b1011;
    parameter KEY_8=8'b00100101;
    parameter KEY_16=16'b1010110011001111;
    
    input [DATA_WIDTH-1:0] data_in;
    input [KEY_WIDTH-1:0] in_key;
    output [DATA_WIDTH-1:0] data_out;
    
    case(KEY_WIDTH)
        1:
        begin
            assign data_out= (in_key==KEY_1)?data_in:
                            1'b0;
        end
        
        2:
        begin
            assign data_out= (in_key==KEY_2)?data_in:
                            data_in^(data_in>>1);
        end
        
        4:
        begin
            assign data_out= (in_key==KEY_4)?data_in:
                            data_in^(data_in>>3);
        end
        
        8:
        begin
            assign data_out= (in_key==KEY_8)?data_in:
                            ~(data_in^(data_in>>4));
        end
        
        16:
        begin
            assign data_out= (in_key==KEY_16)?data_in
                            :~data_in^(data_in>>7);
        end
    endcase
endmodule