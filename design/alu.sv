`timescale 1ns / 1ps

module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )
        (
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB,

        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic[DATA_WIDTH-1:0] ALUResult
        );
    
        always_comb
        begin
                // fazer as combinações aqui, tomando cuidado para combinar
            case(Operation)
            4'b0000:        // AND
                    ALUResult = SrcA & SrcB;
            4'b0001:        // or
                    ALUResult = SrcA | SrcB;
            4'b0010:        // ADD
                    ALUResult = $signed(SrcA) + $signed(SrcB);
            4'b0011:        // 
                    ALUResult = 32'b1; // nada
            4'b0100:        // slli //TODO Fazer o check de numeros negativos nao consegui fazer
                    ALUResult = $signed(SrcA) << $signed(SrcB); 
            4'b0101:        // srli
                    ALUResult = 32'b1; // nada
            4'b0110:        // sub
                    ALUResult = $signed(SrcA) - $signed(SrcB);
            4'b0111:        // srai
                    ALUResult = 32'b1; // nada
            4'b1000:        // Equal/beq
                    ALUResult = (SrcA == SrcB) ? 1 : 0;
            4'b1001:        // xor
                    ALUResult = SrcA ^ SrcB;
            4'b1010:        // 
                    ALUResult = 32'b1; // nada
            4'b1011:        // 
                    ALUResult = 32'b1; // nada
            4'b1100:        // slti
                    ALUResult = 32'b1; // nada
            4'b1101:        // 
                    ALUResult = 32'b1; // nada
            4'b1110:        // 
                    ALUResult = 32'b1; // nada
            4'b1111:        // 
                    ALUResult = 32'b1; // nada
            default:
                    ALUResult = 32'b1;
            endcase
        end
endmodule

