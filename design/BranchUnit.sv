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

    input logic jal,
    input logic jalr
);

always @(PC_Full) begin
    //$display("Pc_full %d + Imm %d = PC_Imm %d -- Jal = %d\n", PC_Full,Imm, PC_Imm, jal);
  end

  always @(jal) begin
    if(jal == 1) begin
      $display("Mudou, pc_im %d\n", PC_Imm);
    end
  end

  logic Branch_Sel;
  logic [31:0] PC_Full;

  assign PC_Full = {23'b0, Cur_PC};
  // provavel nao precise mudar aqui pois ele ja pega o resultado de uma operação
  assign PC_Imm = PC_Full + Imm;
  assign PC_Four = PC_Full + 32'b100;
  assign Branch_Sel = (Branch && AluResult[0]) || jal;  // 0:Branch is taken; 1:Branch is not taken

  assign BrPC = (Branch_Sel) ? PC_Imm : 32'b0;  // Branch -> PC+Imm   // Otherwise, BrPC value is not important
  assign PcSel = Branch_Sel;  // 1:branch is taken; 0:branch is not taken(choose pc+4)

endmodule
