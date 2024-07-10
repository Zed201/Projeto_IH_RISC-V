`timescale 1ns / 1ps

module flopr #(
    parameter WIDTH = 8
) (
    input logic clk,
    reset,
    input logic [WIDTH-1:0] d,
    input logic stall,
    output logic [WIDTH-1:0] q,
    input logic Halt
);
  

  always_ff @(posedge clk, posedge reset, Halt) begin
     if (reset) q <= 0;
     else if (!stall) q <= d;
  end

endmodule
