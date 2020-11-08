`include "lib/opcodes.v"
`timescale 1ns / 1ps

module ALU
 (input      [`W_OPCODE-1:0]  alu_op,
  input      [`W_CPU-1:0]     A,
  input      [`W_CPU-1:0]     B,
  output reg [`W_CPU-1:0]     R,
  output reg overflow,
  output reg isZero);


  always @* begin
    case(alu_op)
      `ADD:  begin DOSOMETHINGNEHRE; end
      `ADDI:  begin DOSOMETHINGNEHRE; end
      `ADDIU:  begin DOSOMETHINGNEHRE; end
      `ADDU:  begin DOSOMETHINGNEHRE; end
      `AND:  begin DOSOMETHINGNEHRE; end
      `ANDI:  begin DOSOMETHINGNEHRE; end
      `NOR:  begin DOSOMETHINGNEHRE; end
      `OR:  begin DOSOMETHINGNEHRE; end
      `ORI:  begin DOSOMETHINGNEHRE; end
      `SLT:  begin DOSOMETHINGNEHRE; end
      `SLTI:  begin DOSOMETHINGNEHRE; end
      `SLTIU:  begin DOSOMETHINGNEHRE; end
      `SLTU:  begin DOSOMETHINGNEHRE; end
      `SLL:  begin DOSOMETHINGNEHRE; end
      `SRL:  begin DOSOMETHINGNEHRE; end
      `SUB:  begin DOSOMETHINGNEHRE; end
      `SUBU:  begin DOSOMETHINGNEHRE; end
      `NOP:  begin DOSOMETHINGNEHRE; end
      default : /*Default catch*/;
    endcase
  end

endmodule
