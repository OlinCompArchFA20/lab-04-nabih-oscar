`include "lib/opcodes.v"
`timescale 1ns / 1ps

module ALU
 #(parameter DLY = 10)
 (input      [`W_OPCODE-1:0]  alu_op,
  input      [`W_CPU-1:0]     A, //Rs
  input      [`W_CPU-1:0]     B, //Rt
  output reg [`W_CPU-1:0]     R, //Rd/Rt
  output reg overflow,
  output reg isZero);

  wire [`W_CPU:0]   carry;
  wire [`W_CPU-1:0] result;
  wire neg;
  wire ovfl;
  wire cout;

  always @* begin
    case(alu_op)
      `ADD:  begin carry[0] = 0; end
      `ADDI:  begin carry[0] = 0; end
      `ADDIU:  begin carry[0] = 0; end
      `ADDU:  begin carry[0] = 0; end
      `AND:  begin carry[0] = 0; end
      `ANDI:  begin carry[0] = 0; end
      `NOR:  begin carry[0] = 0; end
      `OR:  begin carry[0] = 0; end
      `ORI:  begin carry[0] = 0; end
      `SLT:  begin carry[0] = 1; end
      `SLTI:  begin carry[0] = 1; end
      `SLTIU:  begin carry[0] = 1; end
      `SLTU:  begin carry[0] = 1; end
      `SLL:  begin carry[0] = 0; end
      `SRL:  begin carry[0] = 0; end
      `SUB:  begin carry[0] = 1; end
      `SUBU:  begin carry[0] = 1; end
      default : /*Default catch*/;
    endcase
  end

  generate genvar i;
    for (i=0;i<(`W_CPU);i=i+1) begin
      ALU_SLICE #(.DLY(DLY)) slice_inst(alu_op,A[i],B[i],carry[i],result[i],carry[i+1]);
    end
  endgenerate

  assign cout = carry[W];
  //Detects overflow
  xor #DLY OVERFLOW_G1(ovfl, carry[W], carry[W-1]);
  xor #DLY OVERFLOW_G2(neg, ovfl, result[W-1]);

  //Assigns overflow for cases
  always @* begin
    case (alu_op)
      `ADD:  begin overflow = neg; end
      `ADDI:  begin overflow = neg; end
      `ADDIU:  begin overflow = carry[W]; end
      `ADDU:  begin overflow = carry[W]; end
      `AND:  begin overflow = 1'b0; end
      `ANDI:  begin overflow = 1'b0; end
      `NOR:  begin overflow = 1'b0; end
      `OR:  begin overflow = 1'b0; end
      `ORI:  begin overflow = 1'b0; end
      `SLT:  begin overflow = 1'b0; end
      `SLTI:  begin overflow = 1'b0; end
      `SLTIU:  begin overflow = 1'b0; end
      `SLTU:  begin overflow = 1'b0; end
      `SLL:  begin overflow = 1'b0; end
      `SRL:  begin overflow = 1'b0; end
      `SUB:  begin overflow = neg; end
      `SUBU:  begin overflow = carry[W]; end
      default: /* default catch */;
    endcase
  end

  integer j;
  //SLT CHECK
  always @* begin
    if (alu_op == `SLT) begin
      if (A == B) begin
        isZero = 0;
      end
      else begin
        isZero = neg;
      end
    end
    else if(alu_op == `SLTU) begin
      if (A == B) begin
        isZero = 0;
      end
      else begin
        isZero = neg;
      end
    end
    else if (alu_op == `SLL) begin
      for (j=0;j<B;j=j+1) begin
          result[j] = 1'b0;
      end
      for (j=B;j<`W_CPU;j=j+1) begin
          result[j] = A[j-B];
      end
    end
    else if (alu_op == `SRL) begin
      for (j=0;j<(`W_CPU-B);j=j+1) begin
          result[j] = A[j+B];
      end
      for (j=0;j<B;j=j+1) begin
          result[j+`W_CPU-B] = A[`W_CPU-1];
      end
    end
  end

  assign R = result;
endmodule
