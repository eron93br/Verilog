`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:    TCC - Eronides Neto
// Engineer:   Eron
// 
// Create Date:    20:13:31 05/25/2016 
// Design Name: 
// Module Name:    mcp3201ad 
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
module mcp3201ad(adcclk,              
				 adcdav,               
 				 adc0d,  				 
				 davadc,
				 adc0data, 
				 adcsck,       
				 adccs=);        
				  
// Transmissao no falling edge do SCLK!

				  
//=======================================================
//  PORT declarations
//=======================================================
			
	input adcclk;               // clock 1.6MHz FPGA
	input adcdav;               // ativa conversao
 	input adc0d; 				// MISO do MCP3201
	output reg davadc=0;        // END OF CONV. FLAG!
	output reg [11:0] adc0data; // 12-bit do MCP3201
	output reg adcsck;          // SCLK do protocolo SPI
	output reg adccs=1;         // CHIP SELECT
				  
reg [6:0] adcstate=0;

//=======================================================
//  CODE
//=======================================================
always@(posedge adcclk)
	begin
		if (adcdav==0)
			begin
				adcstate=0;
				adcsck=0;
				adccs=1;
				davadc=0;	         //  saida nao disponivel
			end
			
		if (adcdav==1 && davadc==0)
			begin
				case (adcstate)
				0: begin
						adccs=0;		   // ADC chip select
						adcsck=1;      // #1
						adcstate=1;
					end
				1: begin
						adcsck=0;	   //  primeiro BIT DESCONHECIDO!
						adcstate=2;
					end
				2: begin
						adcsck=1;      // #2
						adcstate=3;
					end
				3: begin
						adcsck=0;	   //  segundo BIT DESCONHECIDO!
						adcstate=4;
					end
				4: begin
						adcsck=1;      // #3
						adcstate=5;
					end
				5: begin
						adcsck=0;	   //    NULL BIT!  >> 1b'0 <<
						adcstate=8;
					end					
				8: begin
						adcsck=1;      // #4
						adcstate=9;
					end
				9: begin
						adcsck=0;      // BIT [11]
						adc0data[11]=adc0d;
						adcstate=10;
					end			
				10: begin
						adcsck=1;      // #5
						adcstate=11;
					end
				11: begin
						adcsck=0;     // BIT [10]
						adc0data[10]=adc0d;
						adcstate=12;
					end			
				12: begin
						adcsck=1;      // #6
						adcstate=13;
					end
				13: begin
						adcsck=0;     // BIT [9]
						adc0data[9]=adc0d;
						adcstate=14;
					end			
				14: begin
						adcsck=1;      // #7
						adcstate=15;
					end
				15: begin
						adcsck=0;     // BIT [8]
						adc0data[8]=adc0d;
						adcstate=16;
					end			
				16: begin
						adcsck=1;      // #8
						adcstate=17;
					end
				17: begin
						adcsck=0;   // BIT [7] 
						adc0data[7]=adc0d;     
						adcstate=18;
						//#0
					end			

				18: begin
						adcsck=0;
						adcstate=40; 
						//#0
					end
			   //----------------------------
				40: begin
				      adcsck=0;
				      adcstate=41;
						//#0
					 end
					 
				41: begin
				      adcsck=1;    // #9 
				      adcstate=19;
						//#0
					 end				
				//-------------------------------	 
				19: begin
						adcsck=0;    // BIT [6]
						adc0data[6]=adc0d;
						adcstate=20;
					end			
				20: begin
						adcsck=1;    // #10
						adcstate=21;
					end
				21: begin
						adcsck=0;   // BIT [5]
						adc0data[5]=adc0d;
						adcstate=22;
					end								
				22: begin
						adcsck=1;    // #11
						adcstate=23;
					end
				23: begin
						adcsck=0;  // BIT [4]
						adc0data[4]=adc0d;
						adcstate=24;
					end			
				24: begin
						adcsck=1;    // #12
						adcstate=25;
					end
				25: begin
						adcsck=0;   // BIT [3]
						adc0data[3]=adc0d;
						adcstate=26;
					end								
				26: begin
						adcsck=1;    // #13
						adcstate=27;
					end
				27: begin
						adcsck=0;   // BIT [2]
						adc0data[2]=adc0d;
						adcstate=28;
					end		
				28: begin
						adcsck=1;    // #14
						adcstate=29;
					end
				29: begin
						adcsck=0;   // BIT [1]
						adc0data[1]=adc0d;
						adcstate=30;
					end								
				30: begin
						adcsck=1;    // #15
						adcstate=31;
					end
				31: begin
						adcsck=0;    // BIT [0]
						adc0data[0]=adc0d;
						adcstate=32;
					end			
				32: begin
						adcsck=1;    // #16
						adcstate=33;
					end
				33: begin
				      adcsck=0; 
                  adcstate=34;						
				    end 
				34: begin
				      adcsck=0; 
						adccs=1;      // CS = 1
						davadc=1;     // FIM DA CONVERSAO!!!! 12-BIT ARE READY!
						adcstate=35;
					end								
				35: adcstate=35;
				default: adcstate=34;
			endcase
		end
	end
endmodule
