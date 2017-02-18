`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:02:49 02/10/2015 
// Design Name: 
// Module Name:    clock 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


module clock(input CLK, input [31:0] clkscale, output reg sclclk);
									// CLK crystal clock oscillator 100 MHz
reg [31:0] clkq = 0;			// clock register, initial value of 0
	
always@(posedge CLK)
	begin
		clkq=clkq+1;			// increment clock register
			if (clkq>=clkscale)  	// clock scaling
				begin
					sclclk=~sclclk;	// output clock
					clkq=0;		// reset clock register
				end
	 end

endmodule