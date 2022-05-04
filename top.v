module top (clk, reset, status, pcsrc, alusrc, aluop, mrw, wb, instr, regrw, immgen_ctrl, out);

	input clk, reset, pcsrc, alusrc, mrw, wb, regrw;
	input [3:0] aluop;
	output [31:0] instr;
	output [3:0] status;	
	input [1:0] immgen_ctrl;
	output [31:0] out;
	
	wire [4:0] rd, rs1, rs2;
	wire [31:0] instr;
	
	wire [31:0] pc_in, pc_out, rom_out, ram_out, alu_out;
	wire [31:0] pc_addA_out, pc_addB_out;
	wire [31:0] pcmux_out;
	
	assign pc_in = pcmux_out;
	
	wire [31:0] rf_out1, rf_out2, immgen_out, alumux_out, alurammux_out;
		
	assign out = alurammux_out;
	
	ProgramCounter pc(clk, reset, pc_in, pc_out);
	Adder32 addA(pc_out, 32'd4, pc_addA_out);
	Adder32 addB(pc_out, immgen_out, pc_addB_out);
	Mux2to1_32bit pcmux(pcsrc, pc_addA_out, pc_addB_out, pcmux_out);
	ROM rom(pc_out, rom_out);
	InstDecoder id(rom_out, rd, rs1, rs2, instr);
	Register rf(rf_out1, rf_out2, rs1, rs2, alurammux_out, rd, regrw, reset, clk);
	Mux2to1_32bit alumux(alusrc, rf_out2, immgen_out, alumux_out);
	ImmGen ig(instr, immgen_out, immgen_ctrl);
	ALU alu(rf_out1, alumux_out, aluop, 1'd0, alu_out, status);
	RAM ram(alu_out[7:0], mrw, clk, rf_out2, ram_out); 
	Mux2to1_32bit alurrammux(wb, ram_out, alu_out, alurammux_out);
	

endmodule

/*module top(clk, reset, ALUSrc, PCSrc, ALUOp, MemWrite, MemToReg, MemRead, RegWrite);

	input clk, reset;
	input ALUSrc;
	input PCSrc;
	input [4:0] ALUOp;
	input MemWrite;
	input MemToReg;
	input MemRead;
	input RegWrite;
	
	//output [4:0] rd;
	//output [4:0] rs1;
	//output [4:0] rs2;
	//output [11:0] imm;
	
	wire [7:0] add4_out;
	wire [7:0] pc_out;
	wire [7:0] addMux_out;
	wire [31:0] is;
	wire [31:0] r_outA, r_outB;
	wire cin, cout;
	wire [31:0] ig_out, alu_out;
	wire [7:0] alu_inA, alu_inB;
	wire ram_RW;
	
	ProgramCounter pc(clk, reset, addMux_out, pc_out);
	ROM mem(pc_out, is);
	InstDecoder id(is, rd, rs1, rs2, imm);
	ImmGen ig(imm, ig_out);
	Mux2to1_8bit addMux(PCSrc, ig_out + pc_out, pc_out + 8'd4, addMux_out);
	Register r(r_outA, r_outB, rs1, rs1, 8'b0, rd, (MemToReg)?ram_out:alu_out, reset, clk);
	Mux2to1_8bit regMux(ALUSrc, r_outB, ig_out, alu_inB);
	ALU alu(r_outA, alu_inB, 3'd0, 1'd0, alu_out);
	RAM ram(alu_out, ram_RW, clk, r_outB, ram_out);
	
	
endmodule*/
