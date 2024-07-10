`timescale 1ns / 1ps

module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4,
        parameter PC_W = 9
        )
        (
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB,

        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic[DATA_WIDTH-1:0] ALUResult,

        input logic jal,
        input logic jalr,
        input logic [PC_W-1:0] Curr_Pc
        );

        // TODO: Verificações de negativo nos de deslocamento
        always_comb
        begin
            case(Operation)
            4'b0000:        // ADD/i
                    ALUResult = $signed(SrcA) + $signed(SrcB);
            4'b0001:        // sub
                    ALUResult = $signed(SrcA) - $signed(SrcB);
            4'b0010:        // xor
                    ALUResult = SrcA ^ SrcB;
            4'b0011:        // or
                    ALUResult = SrcA | SrcB;
            4'b0100:        // and
                    ALUResult = SrcA & SrcB;
            4'b0101:        // slt/i
                    ALUResult = ($signed(SrcA) < $signed(SrcB))? 1 : 0;
            4'b0110:        // srai(atenção)
                    ALUResult = $signed(SrcA) >>> $signed(SrcB[4:0]);
            4'b0111:        // srli
                    ALUResult = $signed(SrcA) >> $signed(SrcB[4:0]);
            4'b1000:        // slli
                    ALUResult = $signed(SrcA) << $signed(SrcB[4:0]);
            4'b1001:        // FEITO PARA load e store
                    ALUResult = 0; // so n fazer nd para ficar organizado
            4'b1010:        // bne 
                    ALUResult = (SrcA != SrcB)? 1 : 0;
            4'b1011:        // blt
                    ALUResult = ($signed(SrcA) < $signed(SrcB))? 1 : 0;
            4'b1100:        // bge
                    ALUResult = ($signed(SrcA) >= $signed(SrcB))? 1 : 0;
            4'b1101:        // beq
                    ALUResult = (SrcA == SrcB)? 1 : 0;
            4'b1110:     // LUI
                    ALUResult = SrcB;
            4'b1111:        // JAL e JALR(guarda pc + 4 no reg que ele ta usando na operação)
                    ALUResult = {23'b0, Curr_Pc + 9'b100};
            default:
                    ALUResult = 0;
            endcase
        end
endmodule
