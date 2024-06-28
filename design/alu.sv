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
            case(Operation)
            4'b0000:        //
                    ALUResult = 0;
            4'b0001:        //
                    ALUResult = 0;
            4'b0010:        //
                    ALUResult = 0;
            4'b0011:        //
                    ALUResult = 0;
            4'b0100:        //
                    ALUResult = 0;
            4'b0101:        //
                    ALUResult = 0;
            4'b0110:        //
                    ALUResult = 0;
            4'b0111:        //
                    ALUResult = 0;
            4'b1000:        //
                    ALUResult = 0;
            4'b1001:        //
                    ALUResult = 0;
            4'b1010:        //
                    ALUResult = 0;
            4'b1011:        //
                    ALUResult = 0;
            4'b1100:        //
                    ALUResult = 0;
            4'b1101:        //
                    ALUResult = 0;
            4'b1110:        //
                    ALUResult = 0;
            4'b1111:        //
                    ALUResult = 0;
            default:
                    ALUResult = 0;
            endcase
        end
endmodule
