`timescale 1ns / 1ps

module Controller (
    //Input
    input logic [6:0] Opcode,
    //7-bit opcode field from the instruction

    //Outputs
    output logic ALUSrc,
    //0: The second ALU operand comes from the second register file output (Read data 2); 
    //1: The second ALU operand is the sign-extended, lower 16 bits of the instruction.
    output logic MemtoReg,
    //0: The value fed to the register Write data input comes from the ALU.
    //1: The value fed to the register Write data input comes from the data memory.
    output logic RegWrite, //The register on the Write register input is written with the value on the Write data input 
    output logic MemRead,  //Data memory contents designated by the address input are put on the Read data output
    output logic MemWrite, //Data memory contents designated by the address input are replaced by the value on the Write data input.
    output logic [1:0] ALUOp,  //00: LW/SW; 01:Branch; 10: Rtype
    output logic Branch,  //0: branch is not taken; 1: branch is taken
    output logic jal,
    output logic jalr,
    output logic halt
);

  logic [6:0] R_TYPE, LW, SW, BR, I_TYPE, LUI, JAL, JALR, HALT;
  assign I_TYPE = 7'b0010011;  //addi, andi, ori, xori, slli, srli, srai
  assign R_TYPE = 7'b0110011;  //add,and
  assign LW = 7'b0000011;  //lw, lb, lbu, lh
  assign SW = 7'b0100011;  //sw
  assign BR = 7'b1100011;  //beq, bne
  assign LUI = 7'b0110111;

  assign JAL = 7'b1101111;  //assign JAL
  assign JALR = 7'b1100111;  //assign JALR

  assign HALT = 7'b1111111;  //assign HALT
  assign ALUSrc = (Opcode == LW || Opcode == SW || Opcode == I_TYPE || Opcode == LUI || Opcode == JALR); // disponibiliza alu
  assign MemtoReg = (Opcode == LW); // leitura de memoria
  assign RegWrite = (Opcode == R_TYPE || Opcode == LW || Opcode == I_TYPE || Opcode == LUI || Opcode == JALR || Opcode == JAL); // escrita em reg
  assign MemRead = (Opcode == LW); //leitura de memoria
  assign MemWrite = (Opcode == SW); // escrita de memoria
  // combinatório para alu.sv
  assign ALUOp[0] = (Opcode == BR || Opcode == LUI || Opcode == JAL || Opcode == JALR);
  assign ALUOp[1] = (Opcode == R_TYPE || Opcode == I_TYPE || Opcode == LUI || Opcode == JAL || Opcode == JALR);

  assign Branch = (Opcode == BR); // branch apenas para condicionais
  assign jal = (Opcode == JAL);
  assign jalr = (Opcode == JALR);
  assign halt = (Opcode == HALT);
endmodule
