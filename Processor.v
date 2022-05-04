module Processor (clk,rst,fin_out);
	input clk,rst;
	output [31:0] fin_out;
	wire [31:0] inst;
	wire [3:0] status;
	wire WB, ALUsrc, PCsrc,RW, MRW;
	wire [3:0] ALU_OP;
	wire [1:0] imm_sel;
	
	Control_unit yeayea (clk,rst,inst,status,ALU_OP,imm_sel,WB,ALUsrc,PCsrc,RW, MRW);
	
	top nahnah (clk, rst, status, PCsrc, ALUsrc, ALU_OP, MRW, WB, inst, RW, imm_sel, fin_out);
	
endmodule 

module Processor_tb (clk, rst, fin_out);

	output reg clk, rst;
	output [31:0] fin_out;
	
	Processor yay (clk,rst,fin_out);
	
	
	initial begin 
	clk=0;
	forever #5 clk=~clk;
	end
	initial begin 
	rst=1;
	#10 rst=0;
	end 
endmodule

	