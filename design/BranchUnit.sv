`timescale 1ns / 1ps

module BranchUnit #(
    parameter PC_W = 9
) (
    input logic [PC_W-1:0] Cur_PC,
    input logic [31:0] Imm,
    input logic Branch,
    input logic [31:0] AluResult,
    output logic [31:0] PC_Imm,
    output logic [31:0] PC_Four,
    output logic [31:0] BrPC,
    output logic PcSel,

    input logic jal, // sinal de jal e jalr
    input logic jalr,
    input logic [31:0] jalr_src, // (reg + imm passado no jalr)
    input logic halt
    );

  logic Branch_Sel;
  logic [31:0] PC_Full;
  logic [8:0] tmp_pc = 0;

  always @(halt) begin
    if(halt == 1 && tmp_pc == 0) begin
      tmp_pc = Cur_PC + 8;    
      //$display("Vai %d\n", tmp_pc);
    end
  end
  always @(Cur_PC) begin
    if(Cur_PC == tmp_pc && Cur_PC != 0 ) begin
      $stop;
    end
  end
  assign PC_Full = {23'b0, Cur_PC};

  // se for jalr ele basicamente pega o dado que vem da alu, no caso a combinação do registrador + imediate
  // se não ele pode ser jal apenas que vai ser o pc + imediate
  assign PC_Imm = (jalr) ? jalr_src : PC_Full + Imm;
  assign PC_Four = PC_Full + 32'b100;
  // se for branch condicional ou incondicional ele da 1
  assign Branch_Sel = (Branch && AluResult[0]) || jal || jalr;  // 0:Branch is taken; 1:Branch is not taken

  assign BrPC = (Branch_Sel) ? PC_Imm : 32'b0;  // Branch -> PC+Imm   // Otherwise, BrPC value is not important
  assign PcSel = Branch_Sel;  // 1:branch is taken; 0:branch is not taken(choose pc+4)

endmodule
