`include "fetch.v"
`include "decode.v"
`include "regfile.v"
`include "alu.v"
`include "memory.v"
`include "lib/opcodes.v"


`timescale 1ns / 1ps

module SINGLE_CYCLE_CPU
  (input clk,
   input rst);

  wire [`W_EN-1:0]      branch_ctrl;
  wire [`W_CPU-1:0]     reg_addr;
  wire [`W_JADDR-1:0]   jump_addr;
  wire [`W_IMM-1:0]     imm_addr;

  wire [`W_REG-1:0]     wa;      // Register Write Address
  wire [`W_REG-1:0]     ra1;     // Register Read Address 1
  wire [`W_REG-1:0]     ra2;     // Register Read Address 2
  wire                  reg_wen; // Register Write Enable
  wire [`W_IMM_EXT-1:0] imm_ext; // 1-Sign or 0-Zero extend
  wire [`W_IMM-1:0]     imm; // Immediate Field
  wire [`W_JADDR-1:0]   addr;    // Jump Addr Field
  wire [`W_FUNCT-1:0]   alu_op;  // ALU OP
  wire [`W_PC_SRC-1:0]  pc_src;  // PC Source
  wire [`W_MEM_CMD-1:0] mem_cmd; // Mem Command
  wire [`W_ALU_SRC-1:0] alu_src; // ALU Source
  wire [`W_REG_SRC-1:0] reg_src;// Mem to Reg

  wire [`W_CPU-1:0]     rd1;
  wire [`W_CPU-1:0]     rd2;
  wire [`W_CPU-1:0]     data_cpu;
  reg [`W_CPU-1:0]      data_ALU;
  reg [`W_CPU-1:0]      Dw;


  wire [`W_CPU-1:0]     inst;

  wire [`W_CPU-1:0]     R; //Rd/Rt
  wire                  overflow;
  wire                  isZero;

  reg [`W_CPU-1:0]     pc_next;


  MEMORY stage_MEMORY(clk, rst, pc_next, inst, mem_cmd, rd2, R, data_cpu);
  DECODE stage_DECODE(inst, wa, ra1, ra2, reg_wen, imm_ext, imm, jump_addr, alu_op, pc_src, mem_cmd, alu_src, reg_src);

  always @* begin
    case(alu_src)
      `ALU_SRC_REG: begin data_ALU = rd2; end
      `ALU_SRC_IMM: begin data_ALU = {imm_ext, imm_ext, imm_ext, imm_ext, imm_ext, imm_ext, imm_ext, imm_ext, imm_ext, imm_ext, imm_ext, imm_ext, imm_ext, imm_ext, imm_ext, imm_ext, imm}; end
      `ALU_SRC_SHA: begin data_ALU = {27'b000000000000000000000000000,ra2}; end
      default:;
    endcase
  end

  //SYSCALL Catch
  always @* begin
    //Is the instruction a SYSCALL?
    if (alu_op == `OP_ZERO &&
        inst[`FLD_FUNCT]  == `F_SYSCAL) begin
        case(rd1)
          1 : $display("SYSCALL  1: a0 = %x",rd2);
          10: begin
                $display("SYSCALL 10: Exiting...");
                $finish;
              end
          default:;
        endcase
    end
  end
  ALU stage_ALU(alu_op, rd1, data_ALU, R, overflow, isZero);
  always @* begin
    case(reg_src)
      `REG_SRC_ALU: begin Dw = R; end
      `REG_SRC_MEM: begin Dw = data_cpu; end
      `REG_SRC_PC: begin Dw = R; end
      default:;
    endcase
  end
  REGFILE stage_REGFILE(clk, rst, reg_wen, wa,Dw, ra1, ra2, rd1, rd2);

  FETCH stage_FETCH(clk, rst, pc_src, branch_ctrl, reg_addr, jump_addr, imm_addr, pc_next);

endmodule
