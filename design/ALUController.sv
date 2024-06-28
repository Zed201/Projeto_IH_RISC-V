`timescale 1ns / 1ps

module ALUController (
    //Inputs
    input logic [1:0] ALUOp, 
    // 2-bit opcode field from the Controller 00: LW/SW/AUIPC; 01:Branch; 10: Rtype/Itype; 11:JAL/LUI
    input logic [6:0] Funct7,  // bits 25 to 31 of the instruction
    input logic [2:0] Funct3,  // bits 12 to 14 of the instruction

    //Output
    output logic [3:0] Operation  // operation selection for ALU
);
    /*
    As operações vão ser combinadas, de acordo com tipos também, aqui, implementadas no alu.sv, basicamente tem que:
    1. not_equal(jump) // mexer no branchunit
    2. less_than(jump)
    3. greater_than(jump)
    4. addi (type I)
    5. sub (type R)
    6. xor (type I)
    7. or (type R)
    8. slt (set less than, basicamente rd <- (rs1 < rs2)? 1 : 0) (type R)
    9. slti (set less than imediate) (type I)
    10. srai (shift rigth aritimetic imediate) (type I)
    11. srli (shift rigth logic imediate) (type I)
    12. slli (shift left logic imediate) (type I)
    */
  assign Operation[0] = ((ALUOp == 2'b10) && (Funct3 == 3'b110)) ||  // R\I-or
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) ||  // R\I->>(srli)
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000));  // R\I->>>(srai)

  assign Operation[1] = (ALUOp == 2'b00) ||  // LW\SW
      ((ALUOp == 2'b10) && (Funct3 == 3'b000)) ||  // R\I-add
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000));  // R\I->>>(srai)

  assign Operation[2] =  ((ALUOp==2'b10) && (Funct3==3'b101) && (Funct7==7'b0000000)) || // R\I->>(srli)
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) ||  // R\I->>>(srai)
      ((ALUOp == 2'b10) && (Funct3 == 3'b001)) ||  // R\I-<<(slli)
      ((ALUOp == 2'b10) && (Funct3 == 3'b010));  // R\I-<(slti ou slt, slt tem func7-000000, o slti n tem func7)
// TODO: ver como diferencia quando tem ou nao func7, principalmente essa duvida do slti e do slt

// para implementar os outros tem que verificar o funct3
  assign Operation[3] = (ALUOp == 2'b01) ||  // BEQ
      ((ALUOp == 2'b10) && (Funct3 == 3'b010));  // R\I-<(slti ou slt)
endmodule