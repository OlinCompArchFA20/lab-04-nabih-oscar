`include "lib/opcodes.v"
`include "alu_slice.v"
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
      `F_ADD:  begin carry[0] = 0; end
      `ADDI:  begin carry[0] = 0; end
      `ADDIU:  begin carry[0] = 0; end
      `F_ADDU:  begin carry[0] = 0; end
      `F_AND:  begin carry[0] = 0; end
      `ANDI:  begin carry[0] = 0; end
      `F_NOR:  begin carry[0] = 0; end
      `F_OR:  begin carry[0] = 0; end
      `ORI:  begin carry[0] = 0; end
      `F_SLT:  begin carry[0] = 1; end
      `SLTI:  begin carry[0] = 1; end
      `SLTIU:  begin carry[0] = 1; end
      `F_SLTU:  begin carry[0] = 1; end
      `F_SLL:  begin carry[0] = 0; end
      `F_SRL:  begin carry[0] = 0; end
      `F_SUB:  begin carry[0] = 1; end
      `F_SUBU:  begin carry[0] = 1; end
      default : /*Default catch*/;
    endcase
  end

  generate genvar i;
    for (i=0;i<(`W_CPU);i=i+1) begin
      ALU_SLICE #(.DLY(DLY)) slice_inst(alu_op,A[i],B[i],carry[i],result[i],carry[i+1]);
    end
  endgenerate

  assign cout = carry[`W_CPU];
  //Detects overflow
  xor #DLY OVERFLOW_G1(ovfl, carry[`W_CPU], carry[`W_CPU-1]);
  xor #DLY OVERFLOW_G2(neg, ovfl, result[`W_CPU-1]);

  //Assigns overflow for cases
  always @* begin
    case (alu_op)
      `F_ADD:  begin overflow = neg; end
      `ADDI:  begin overflow = neg; end
      `ADDIU:  begin overflow = carry[`W_CPU]; end
      `F_ADDU:  begin overflow = carry[`W_CPU]; end
      `F_AND:  begin overflow = 1'b0; end
      `ANDI:  begin overflow = 1'b0; end
      `F_NOR:  begin overflow = 1'b0; end
      `F_OR:  begin overflow = 1'b0; end
      `ORI:  begin overflow = 1'b0; end
      `F_SLT:  begin overflow = 1'b0; end
      `SLTI:  begin overflow = 1'b0; end
      `SLTIU:  begin overflow = 1'b0; end
      `F_SLTU:  begin overflow = 1'b0; end
      `F_SLL:  begin overflow = 1'b0; end
      `F_SRL:  begin overflow = 1'b0; end
      `F_SUB:  begin overflow = neg; end
      `F_SUBU:  begin overflow = carry[`W_CPU]; end
      default: /* default catch */;
    endcase
  end

  integer j;
  //SLT CHECK
  always @* begin
    if (alu_op == `F_SLT) begin
      if (A == B) begin
        isZero = 0;
      end
      else begin
        isZero = neg;
      end
    end
    else if(alu_op == `F_SLTU) begin
      if (A == B) begin
        isZero = 0;
      end
      else begin
        isZero = neg;
      end
    end
    else if (alu_op == `SLTI) begin
      if (A == B) begin
        isZero = 0;
      end
      else begin
        isZero = neg;
      end
    end
    else if(alu_op == `SLTIU) begin
      if (A == B) begin
        isZero = 0;
      end
      else begin
        isZero = neg;
      end
    end
    else if (alu_op == `F_SLL) begin
      for (j=0;j<B;j=j+1) begin
          R[j] = 1'b0;
      end
      for (j=B;j<`W_CPU;j=j+1) begin
          R[j] = A[j-B];
      end
    end
    else if (alu_op == `F_SRL) begin
      for (j=0;j<(`W_CPU-B);j=j+1) begin
          R[j] = A[j+B];
      end
      for (j=0;j<B;j=j+1) begin
          R[j+`W_CPU-B] = A[`W_CPU-1];
      end
    end
    else begin
      R = result;
    end
  end
endmodule
