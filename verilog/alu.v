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

  assign overflow = 1'b0;
  assign isZero = 1'b0;
  //Assigns overflow for cases
  integer j;
  always @* begin
    case (alu_op)
      `F_ADD:  begin R = A+B; end
      `ADDI:  begin R = A+B; end
      `ADDIU:  begin R = A+B; end
      `F_ADDU:  begin R = A+B; end
      `F_AND:  begin R = A&B; end
      `ANDI:  begin R = A&B; end
      `F_NOR:  begin R = ~(A|B); end
      `F_OR:  begin R = A|B; end
      `ORI:  begin R = A|B; end
      `F_SLT:  begin R = A<B; end
      `SLTI:  begin R = A<B; end
      `SLTIU:  begin R = A<B; end
      `F_SLTU:  begin R = A<B; end
      `F_SLL: begin R = A<<B; end
      `F_SRL: begin R = A>>B; end
      `F_SUB:  begin R = A-B; end
      `F_SUBU:  begin R = A-B; end
      `XORI:  begin R = A^B; end
      `LW:  begin R = A+B; end
      `SW:  begin R = A+B; end
      default: /* default catch */;
    endcase

  end
  // reg [`W_CPU:0]   carry;
  // reg [`W_CPU-1:0] result;
  // wire neg;
  // wire ovfl;
  // wire cout;
  //
  // always @* begin
  //   if (alu_op == `F_SLT || alu_op == `F_SLTU || alu_op == `SLTI || alu_op == `SLTIU || alu_op == `F_SUB || alu_op == `F_SUBU) begin
  //     carry[0] = 1;
  //   end
  // end
  //
  // generate genvar i;
  //   for (i=0;i<(`W_CPU);i=i+1) begin
  //     ALU_SLICE #(.DLY(DLY)) slice_inst(alu_op,A[i],B[i],carry[i],result[i],carry[i+1]);
  //   end
  // endgenerate
  //
  // assign cout = carry[`W_CPU];
  // //Detects overflow
  // xor #DLY OVERFLOW_G1(ovfl, carry[`W_CPU], carry[`W_CPU-1]);
  // xor #DLY OVERFLOW_G2(neg, ovfl, result[`W_CPU-1]);
  //
  // //Assigns overflow for cases
  // always @* begin
  //   case (alu_op)
  //     `F_ADD:  begin overflow = neg; end
  //     `ADDI:  begin overflow = neg; end
  //     `ADDIU:  begin overflow = carry[`W_CPU]; end
  //     `F_ADDU:  begin overflow = carry[`W_CPU]; end
  //     `F_AND:  begin overflow = 1'b0; end
  //     `ANDI:  begin overflow = 1'b0; end
  //     `F_NOR:  begin overflow = 1'b0; end
  //     `F_OR:  begin overflow = 1'b0; end
  //     `ORI:  begin overflow = 1'b0; end
  //     `F_SLT:  begin overflow = 1'b0; end
  //     `SLTI:  begin overflow = 1'b0; end
  //     `SLTIU:  begin overflow = 1'b0; end
  //     `F_SLTU:  begin overflow = 1'b0; end
  //     `F_SLL:  begin overflow = 1'b0; end
  //     `F_SRL:  begin overflow = 1'b0; end
  //     `F_SUB:  begin overflow = neg; end
  //     `F_SUBU:  begin overflow = carry[`W_CPU]; end
  //     default: /* default catch */;
  //   endcase
  // end
  //
  // integer j;
  // //SLT CHECK
  // always @* begin
  //   if (alu_op == `F_SLT || alu_op == `F_SLTU || alu_op == `SLTI || alu_op == `SLTIU) begin
  //     if (A == B) begin
  //       isZero = 0;
  //     end
  //     else begin
  //       isZero = neg;
  //     end
  //   end
  //   else if (alu_op == `F_SLL) begin
  //     for (j=0;j<B;j=j+1) begin
  //         R[j] = 1'b0;
  //     end
  //     for (j=B;j<`W_CPU;j=j+1) begin
  //         R[j] = A[j-B];
  //     end
  //   end
  //   else if (alu_op == `F_SRL) begin
  //     for (j=0;j<(`W_CPU-B);j=j+1) begin
  //         R[j] = A[j+B];
  //     end
  //     for (j=0;j<B;j=j+1) begin
  //         R[j+`W_CPU-B] = A[`W_CPU-1];
  //     end
  //   end
  //   else begin
  //     R = 32'd10;
  //   end
  // end
endmodule
