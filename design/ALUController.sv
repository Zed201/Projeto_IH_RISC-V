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
    // padrão:
  /*assign Operation[0] = ((ALUOp == 2'b10) && (Funct3 == 3'b110)) ||  // R\I-or
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) ||  // R\I->>(srli)
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000));  // R\I->>>(srai)

  assign Operation[1] = (ALUOp == 2'b00) ||  // LW\SW
      ((ALUOp == 2'b10) && (Funct3 == 3'b000)) ||  // R\I-add
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000));  // R\I->>>(srai)

  assign Operation[2] =  ((ALUOp==2'b10) && (Funct3==3'b101) && (Funct7==7'b0000000)) || // R\I->>(srli)
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) ||  // R\I->>>(srai)
      ((ALUOp == 2'b10) && (Funct3 == 3'b001)) ||  // R\I-<<(slli)
      ((ALUOp == 2'b10) && (Funct3 == 3'b010));  // R\I-<(slti ou slt, slt tem func7-000000, o slti n tem func7)

  assign Operation[3] = (ALUOp == 2'b01) ||  // BEQ
      ((ALUOp == 2'b10) && (Funct3 == 3'b010));  // R\I-<(slti ou slt)*/

/*
    As operações vão ser combinadas, de acordo com tipos também, aqui, implementadas no alu.sv, basicamente tem que:

    4. addi (type I) (ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0000000) -
    5. sub (type R) (ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0100000) -
    6. xor (type I) (ALUOp == 2'b10) && (Funct3 == 3'b100) && (Funct7 == 7'b0000000) -
    7. or (type R) (ALUOp == 2'b10) && (Funct3 == 3'b110) && (Funct7 == 7'b0000000) -
    14. add (type R) (ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0000000) - 
    15. and (type I) (ALUOp == 2'b10) && (Funct3 == 3'b111) && (Funct7 == 7'b0000000)

    8. slt (set less than, basicamente rd <- (rs1 < rs2)? 1 : 0) (type R) -
    (ALUOp == 2'b10) && (Funct3 == 3'b010) && (Funct7 == 7'b0000000)

    9. slti (set less than imediate) (type I) // fazer o mesmo do slt - 
    (ALUOp == 2'b10) && (Funct3 == 3'b010)

    10. srai (shift rigth aritimetic imediate) (type I) - 
    (ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)

    11. srli (shift rigth logic imediate) (type I) - 
    (ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)

    12. slli (shift left logic imediate) (type I)
    (ALUOp == 2'b10) && (Funct3 == 3'b001) && (Funct7 == 7'b0000000)

    1. not_equal(type B) bne 
    (ALUOp == 2'b01) && (Funct3 == 3'b001)

    2. less_than(type B) blt 
    (ALUOp == 2'b01) && (Funct3 == 3'b100)

    3. greater_than(type B) bge 
    (ALUOp == 2'b01) && (Funct3 == 3'b101)

    13. beq 
    (ALUOp == 2'b01) && (Funct3 == 3'b000)

    16. lw/sw_load (ALUOp == 2'b00) 

    17. lui (ALUOp == 2'b11) && (Funct3 != 7'b000)

    18. jal/jalr (ALUOp == 2'b11) && (Funct3 == 7'b000) && (Funct7 == 7'b0000000)
    
    */

    // always @(ALUOp, Funct3, Funct7) begin
    //     $display("Aluop: %b, f3: %b, f7: %b\n", ALUOp, Funct3, Funct7);
    // end
  assign Operation[0] = ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0100000)) ||
                        ((ALUOp == 2'b10) && (Funct3 == 3'b110) && (Funct7 == 7'b0000000)) ||
                        ((ALUOp == 2'b10) && (Funct3 == 3'b010)) ||
                        ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b100)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b000)) ||
                        (ALUOp == 2'b11) && (Funct3 == 7'b000) && (Funct7 == 7'b0000000);

  assign Operation[1] = ((ALUOp == 2'b10) && (Funct3 == 3'b100) && (Funct7 == 7'b0000000)) ||
                        ((ALUOp == 2'b10) && (Funct3 == 3'b110) && (Funct7 == 7'b0000000)) ||
                        ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) ||
                        ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b001)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b100)) ||
                        ((ALUOp == 2'b11) && (Funct3 != 7'b000) && (Funct7 != 7'b0000000)) ||
                        (ALUOp == 2'b11) && (Funct3 == 7'b000) && (Funct7 == 7'b0000000);

  assign Operation[2] = ((ALUOp == 2'b10) && (Funct3 == 3'b111) && (Funct7 == 7'b0000000)) ||
                        ((ALUOp == 2'b10) && (Funct3 == 3'b010)) ||
                        ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) ||
                        ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b101)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b000)) ||
                        ((ALUOp == 2'b11) && (Funct3 != 7'b000) && (Funct7 != 7'b0000000)) ||
                        (ALUOp == 2'b11) && (Funct3 == 7'b000) && (Funct7 == 7'b0000000);  

  assign Operation[3] = ((ALUOp == 2'b10) && (Funct3 == 3'b001) && (Funct7 == 7'b0000000)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b001)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b100)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b101)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b000)) ||
                        ((ALUOp == 2'b11) && (Funct3 != 7'b000) && (Funct7 != 7'b0000000)) ||
                        (ALUOp == 2'b11) && (Funct3 == 7'b000) && (Funct7 == 7'b0000000);

endmodule