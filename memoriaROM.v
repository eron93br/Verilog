module atlusbuart (input CLK, BTND, RXD, output TXD,[6:0] LED); 

wire [7:0] tdin;
wire [7:0] rbr1,rbr2;
wire tbuf, rdrst, clk16x, wrn, txd, rxd, rdrdy1,rdrdy2, genclk,finish,clk2;
wire [3:0] S1,S2,S3,S4,C1,C2,C3,C4;
wire [31:0] memory;
wire [9:0] sen,cos;
wire act_calc,act_screen,dcalc,dav;
wire [6:0] N1,N2,dataout;
assign rxd=RXD;
assign TXD=txd;

clock M0 (CLK, 326, clk16x);		// 9600 b/sec
clock M1 (CLK, 5000, genclk);	   // 10 kHz
clock M10 (CLK, 7500, clk2);
rcvr M2 (rbr1, rdrdy1, rxd, clk16x, rdrst);
txmit M3 (tdin, tbuf, clk16x, wrn, txd);
genusbuart M4 (genclk, BTND, rdrst, rbr1,rbr2, rdrdy1,rdrdy2, tdin, tbuf, wrn);
savefsm M5(CLK,rdrdy1,rbr1,dataout,dav,LED);
calculator M6(CLK,act_calc,S1,S2,S3,S4,C1,C2,C3,C4,memory,dcalc);
screen M8(tbuf,clk2,act_screen,memory,rbr2,rdrdy2,finish);

sen_memory MM1(dataout,sen);       // returns sin and cos (10-bit)
sen_memory MM2((7'd90-dataout),cos);
bcd B1(sen,S1,S2,S3,S4);
bcd B2(cos,C1,C2,C3,C4);




controller M15 (CLK,dav,dcalc,act_calc,act_screen);

endmodule

module genusbuart(input genclk, BTND, output reg rdrst=0, input [7:0] rbr1,rbr2,
                  input rdrdy1,rdrdy2, output reg [7:0] tdin, input tbuf,
						output reg wrn);
					
reg [2:0] gstate=0;		// state register

always@(posedge genclk)
	begin
		if (BTND==1)		// reset
				gstate=0;
		else
		
		case (gstate)
			0:	begin
					rdrst=1;		// reset UART
					gstate=1;
				end
			1:	begin
					rdrst=0;
					gstate=2;
				end	
			2: begin
					if (rdrdy1==1)	// receive data ready?
						begin
							tdin=rbr1;	// receiver buffer->transmit input 
							gstate=3;
						end

					if (rdrdy2==1)	// receive data ready?
						begin
							tdin=rbr2;	// receiver buffer->transmit input 
							gstate=3;
						end
				end
			3: begin
					if (tbuf==0)	// transmit buffer empty?
						begin
							wrn=1;	// write transmit input to txmit
							gstate=4;
						end
				end
			4: begin
					wrn=0;
					if (tbuf==0)	// transmit buffer cleared?
						gstate=0;
				end
			default: gstate=0;
		endcase
	end
endmodule
