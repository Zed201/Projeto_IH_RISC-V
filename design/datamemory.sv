`timescale 1ns / 1ps

module datamemory #(
    parameter DM_ADDRESS = 9,
    parameter DATA_W = 32
) (
    input logic clk,
    input logic MemRead,  // comes from control unit
    input logic MemWrite,  // Comes from control unit
    input logic [DM_ADDRESS - 1:0] a,  // Read / Write address - 9 LSB bits of the ALU output
    input logic [DATA_W - 1:0] wd,  // Write Data
    input logic [2:0] Funct3,  // bits 12 to 14 of the instruction
    output logic [DATA_W - 1:0] rd  // Read Data
);

  logic [31:0] raddress;
  logic [31:0] waddress;
  logic [31:0] Datain;
  logic [31:0] Dataout;
  logic [ 3:0] Wr;

  Memoria32Data mem32 (
      .raddress(raddress),
      .waddress(waddress),
      .Clk(~clk),
      .Datain(Datain),
      .Dataout(Dataout),
      .Wr(Wr)
  );

  always_ff @(*) begin
    //raddress = {{22{1'b0}}, a[8:2], {2{1'b0}}};
    waddress = {{22{1'b0}}, a[8:2], {2{1'b0}}};
    Datain = wd;
    Wr = 4'b0000;
    // O read ele basicamente le de 4 em 4 bytes, ou seja de word em word, para acertar devemos acertar os locais de leitura
    if (MemRead) begin
      case (Funct3)
        3'b010: begin  //LW
          raddress <= {{22{1'b0}}, a[8:2], {2{1'b0}}}; // corta os endereços de 4 em 4
          rd <= Dataout;
        end
        3'b001: begin  //LH
          raddress <= {{22{1'b0}}, a[8:1], {1'b0}}; // corta os endereços de 2 em 2
          rd <= $signed(Dataout[15:0]);
        end
        3'b100: begin  //LBU
          raddress <= {{22{1'b0}}, a}; // corta os endereços de 1 em 1 em unsigned
          rd <= $unsigned(Dataout[7:0]); // acertar unsigned
        end
        3'b000: begin  //LB
          raddress <= {{22{1'b0}}, a}; // corta os endereços de 1 em 1 com sinal
          rd <= $signed(Dataout[7:0]);
        end
        default: rd <= Dataout;
      endcase
    end else if (MemWrite) begin // TODO: Resolver sb e sh
      case (Funct3)
        3'b001: begin  //SH
          Wr <= 4'b0011;
          Datain[15:0] <= wd;
        end
        3'b000: begin  //SB
          Wr <= 4'b0001;
          Datain[7:0] <= wd;
        end
        3'b010: begin  //SW
          Wr <= 4'b1111;
          Datain <= wd;
        end
        default: begin
          Wr <= 4'b1111;
          Datain <= wd;
        end
      endcase
    end
  end

endmodule
