
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:    TCC - Eronides Neto
// Engineer:   Eron
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// Modulo responsavel por mandar 16-bit para o MCP4821 , PROTOCOLO SPI
// MSB FIRST - MANDA DADO NO PULSO POSITIVO DO SCLK
//////////////////////////////////////////////////////////////////////////////////
//   _      _     ________      _____ 
//  | \    / |   |             |     |
//  |  \  /  |   |             |     |
//  |   \/   |   |             |     |
//  |        |   |             |_____| 
//  |        |   |             |
//  |        |   |________     |
//                

module mcp4921da(input dacclk,                // CLK to convert 
                 input dacdav,                // Start DA Conversion!
					  input [11:0] dacdata,        // 12-bit digital to be converted to analog
                 input [1:0] daccmd,          // 2-bit to Define MCP8421 operation - config bits
					  output reg dacout,           // MOSI
				  	  output reg dacsck=0,         // SCLK of MCP4821
					  output reg davdac,           // Flag Status - end of conversion
					  output reg dacsync=1'b1);
					  
	  // 0 - X - GA - SHDN - D11 - D10 - D9 - D8 - D7 - D6 - D5 - D4 - D3 - D2 - D1 - D0
	  // ====================================
	  // ==0 - X - 0  -  1   - 12-BIT DATA ==
	  // ====================================
					
reg [5:0] dacstate=0;

always@(posedge dacclk)
	begin
		if (dacdav==0)		// DAC data?	
				begin
					dacstate=0;
					davdac=0;	// DAC data NAK
				end
			
		if (dacdav==1 && davdac==0)
			begin
				case (dacstate)
				0: begin
						dacsync=1;
						dacsck=0;    // define zero for send the SPI data on the rising edge of SCLK
						dacstate=1;
					end
				1: begin
						dacsync=0;
						dacout=0;	 // DATA15
						dacstate=2;
					end
				2: begin
						dacsck=1;    // Send d15
						dacstate=3;  // #1 CLK
					end
				3: begin
						dacsck=0;
						dacout=1;	// X don't care - DATA14
						dacstate=4;
					end			
				4: begin
						dacsck=1;    // Send d14
						dacstate=5;  // #2 CLK
					end
				5: begin
						dacsck=0;
						dacout=0; // DATA13  -- mandar bit 0 para ser 2x 
						dacstate=6;
					end			
				6: begin
						dacsck=1;    // Send d13
						dacstate=7;  // #3 CLK
					end
				7: begin
						dacsck=0;
						dacout=1;  // DATA12 -- MANDAR BIT 1!!!
						dacstate=8;
					end			
				8: begin
						dacsck=1;     // Send d12
						dacstate=9;   // #4 CLK
					end
				9: begin
						dacsck=0; 
						dacout=dacdata[11]; // data 11
						dacstate=10;
					end
				10: begin
						dacsck=1;        // Send d11
						dacstate=11;     // #5 CLK
					end
				11: begin
						dacsck=0;
						dacout=dacdata[10];  // DATA 10
						dacstate=12;
					end			
				12: begin
						dacsck=1;       // Send d10
						dacstate=13;    // #6 CLK
					end
				13: begin
						dacsck=0;         
						dacout=dacdata[9];  // data 9
						dacstate=14;
					end			
				14: begin
						dacsck=1;       // Send d9
						dacstate=15;    // #7 CLK
					end
				15: begin
						dacsck=0;
						dacout=dacdata[8];  // data 8
						dacstate=16;
					end			
				16: begin
						dacsck=1;       // send d8
						dacstate=17;    // #8 CLK
					end
				17: begin
						dacsck=0;
						dacout=dacdata[7];  // data 7
						dacstate=18;
					end			
				18: begin
						dacsck=1;       // send d7 
						dacstate=19;    // #9 CLK
					end
				19: begin
						dacsck=0;
						dacout=dacdata[6];  // data 6
						dacstate=20;
					end								
				20: begin
						dacsck=1;       // send d6
						dacstate=21;    // #10 CLK
					end
				21: begin
						dacsck=0;
						dacout=dacdata[5];   // data 5
						dacstate=22;
					end			
				22: begin
						dacsck=1;       // send d5
						dacstate=23;    // #11 CLK
					end
				23: begin
						dacsck=0;
						dacout=dacdata[4];  // data 4
						dacstate=24;
					end								
				24: begin
						dacsck=1;      // send d4
						dacstate=25;     // #12 CLK
					end
				25: begin
						dacsck=0;       
						dacout=dacdata[3];   // data 3
						dacstate=26;
					end		
				26: begin
						dacsck=1;     // send d3
						dacstate=27;  // #13 CLK
					end
				27: begin
						dacsck=0;
						dacout=dacdata[2];    /// data 2
						dacstate=28;
					end								
				28: begin
						dacsck=1;      // send d2
						dacstate=29;   // #14 CLK
					end
				29: begin
						dacsck=0;
						dacout=dacdata[1];    // data1
						dacstate=30;
					end			
				30: begin
						dacsck=1;   // send d1
						dacstate=31;    // #15 CLK
					end
				31: begin
						dacsck=0;
						dacout=dacdata[0];  // data 0
						dacstate=32;
					end								
				32: begin
						dacsck=1;   // send d0
						dacstate=33;     // #16 CLK -----------
					end
					
				33: begin
				      dacsck=0;
						dacstate=34;
					 end
					 
				34: begin
						dacsync=1;
						dacsck=0;
						davdac=1;	// DAC data ACK	
						dacstate=35;
					end		
					
				35: dacstate=35;
				
				default: dacstate=35;
			endcase
		end
	end
endmodule

