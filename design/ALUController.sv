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

    1. addi (type I) (ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0000000)

    2. sub (type R) (ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0100000)

    3. xor (type I) (ALUOp == 2'b10) && (Funct3 == 3'b100) && (Funct7 == 7'b0000000)

    4. or (type R) (ALUOp == 2'b10) && (Funct3 == 3'b110) && (Funct7 == 7'b0000000) 

    5. add (type R) (ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0000000)

    6. and (type I) (ALUOp == 2'b10) && (Funct3 == 3'b111) && (Funct7 == 7'b0000000)

    7. slt (set less than, basicamente rd <- (rs1 < rs2)? 1 : 0) (type R)
    (ALUOp == 2'b10) && (Funct3 == 3'b010) && (Funct7 == 7'b0000000)

    8. slti (set less than imediate) (type I) // fazer o mesmo do slt - 
    (ALUOp == 2'b10) && (Funct3 == 3'b010)

    9. srai (shift rigth aritimetic imediate) (type I)
    (ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)

    10. srli (shift rigth logic imediate) (type I)
    (ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)

    11. slli (shift left logic imediate) (type I)
    (ALUOp == 2'b10) && (Funct3 == 3'b001) && (Funct7 == 7'b0000000)

    12. not_equal(type B) bne 
    (ALUOp == 2'b01) && (Funct3 == 3'b001)

    13. less_than(type B) blt 
    (ALUOp == 2'b01) && (Funct3 == 3'b100)

    14. greater_than(type B) bge 
    (ALUOp == 2'b01) && (Funct3 == 3'b101)

    15. beq 
    (ALUOp == 2'b01) && (Funct3 == 3'b000)

    16. lw/sw_load (ALUOp == 2'b00) 

    17. lui (ALUOp == 2'b11) && (Funct3 != 7'b000)

    18. jal/jalr (ALUOp == 2'b11) && (Funct3 == 7'b000) && (Funct7 == 7'b0000000)
    
    */

  assign Operation[0] = ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0100000)) ||
                        ((ALUOp == 2'b10) && (Funct3 == 3'b110) && (Funct7 == 7'b0000000)) ||
                        ((ALUOp == 2'b10) && (Funct3 == 3'b010)) ||
                        ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b100)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b000)) ||
                        ((ALUOp == 2'b11) && (Funct3 == 7'b000) && (Funct7 == 7'b0000000));

  assign Operation[1] = ((ALUOp == 2'b10) && (Funct3 == 3'b100) && (Funct7 == 7'b0000000)) ||
                        ((ALUOp == 2'b10) && (Funct3 == 3'b110) && (Funct7 == 7'b0000000)) ||
                        ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) ||
                        ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b001)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b100)) ||
                        ((ALUOp == 2'b11) && (Funct3 != 7'b000) && (Funct7 != 7'b0000000)) ||
                        ((ALUOp == 2'b11) && (Funct3 == 7'b000) && (Funct7 == 7'b0000000));

  assign Operation[2] = ((ALUOp == 2'b10) && (Funct3 == 3'b111) && (Funct7 == 7'b0000000)) ||
                        ((ALUOp == 2'b10) && (Funct3 == 3'b010)) ||
                        ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) ||
                        ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b101)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b000)) ||
                        ((ALUOp == 2'b11) && (Funct3 != 7'b000) && (Funct7 != 7'b0000000)) ||
                        ((ALUOp == 2'b11) && (Funct3 == 7'b000) && (Funct7 == 7'b0000000));  

  assign Operation[3] = ((ALUOp == 2'b10) && (Funct3 == 3'b001) && (Funct7 == 7'b0000000)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b001)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b100)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b101)) ||
                        ((ALUOp == 2'b01) && (Funct3 == 3'b000)) ||
                        ((ALUOp == 2'b11) && (Funct3 != 7'b000) && (Funct7 != 7'b0000000)) ||
                        ((ALUOp == 2'b11) && (Funct3 == 7'b000) && (Funct7 == 7'b0000000));

endmodule