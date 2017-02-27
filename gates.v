//
// lab1 : version 01/19/2015
//           
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module gates(
    input a0, input b0, output f0, input a1, input b1, output f1,
    input a2, input b2, output f2, input a3, input b3, output f3
    );
	 and (f0,a0,b0);
    or(f1,a1,b1);
	 xor(f2,a2,b2);
	 nand(f3,a3,b3);
	// Write code starting here ...

endmodule
