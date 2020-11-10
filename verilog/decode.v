`include "lib/opcodes.v"
`include "lib/debug.v"
`timescale 1ns / 1 ps

module DECODE
 (input [`W_CPU-1:0] inst,

  // Register File control
  output reg [`W_REG-1:0]     wa,      // Register Write Address
  output reg [`W_REG-1:0]     ra1,     // Register Read Address 1
  output reg [`W_REG-1:0]     ra2,     // Register Read Address 2
  output reg                  reg_wen, // Register Write Enable
  // Immediate
  output reg [`W_IMM_EXT-1:0] imm_ext, // 1-Sign or 0-Zero extend
  output reg [`W_IMM-1:0]     imm,     // Immediate Field
  // Jump Address
  output reg [`W_JADDR-1:0]   jump_addr,    // Jump Addr Field
  // ALU Control
  output reg [`W_FUNCT-1:0]   alu_op,  // ALU OP
  // Muxing
  output reg [`W_PC_SRC-1:0]  pc_src,  // PC Source
  output reg [`W_MEM_CMD-1:0] mem_cmd, // Mem Command
  output reg [`W_ALU_SRC-1:0] alu_src, // ALU Source
  output reg [`W_REG_SRC-1:0] reg_src);// Mem to Reg

  // Unconditionally pull some instruction fields
  wire [`W_REG-1:0] rs;
  wire [`W_REG-1:0] rt;
  wire [`W_REG-1:0] rd;
  assign rs   = inst[`FLD_RS];
  assign rt   = inst[`FLD_RT];
  assign rd   = inst[`FLD_RD];
  assign imm  = inst[`FLD_IMM];
  assign jump_addr = inst[`FLD_ADDR];


  always @* begin
    case(inst[`FLD_OPCODE])
      // Here be dragons.
      // @@@@@@@@@@@@@@@@@@@@@**^^""~~~"^@@^*@*@@**@@@@@@@@@
      // @@@@@@@@@@@@@*^^'"~   , - ' '; ,@@b. '  -e@@@@@@@@@
      // @@@@@@@@*^"~      . '     . ' ,@@@@(  e@*@@@@@@@@@@
      // @@@@@^~         .       .   ' @@@@@@, ~^@@@@@@@@@@@
      // @@@~ ,e**@@*e,  ,e**e, .    ' '@@@@@@e,  "*@@@@@'^@
      // @',e@@@@@@@@@@ e@@@@@@       ' '*@@@@@@    @@@'   0
      // @@@@@@@@@@@@@@@@@@@@@',e,     ;  ~^*^'    ;^~   ' 0
      // @@@@@@@@@@@@@@@^""^@@e@@@   .'           ,'   .'  @
      // @@@@@@@@@@@@@@'    '@@@@@ '         ,  ,e'  .    ;@
      // @@@@@@@@@@@@@' ,&&,  ^@*'     ,  .  i^"@e, ,e@e  @@
      // @@@@@@@@@@@@' ,@@@@,          ;  ,& !,,@@@e@@@@ e@@
      // @@@@@,~*@@*' ,@@@@@@e,   ',   e^~^@,   ~'@@@@@@,@@@
      // @@@@@@, ~" ,e@@@@@@@@@*e*@*  ,@e  @@""@e,,@@@@@@@@@
      // @@@@@@@@ee@@@@@@@@@@@@@@@" ,e@' ,e@' e@@@@@@@@@@@@@
      // @@@@@@@@@@@@@@@@@@@@@@@@" ,@" ,e@@e,,@@@@@@@@@@@@@@
      // @@@@@@@@@@@@@@@@@@@@@@@~ ,@@@,,0@@@@@@@@@@@@@@@@@@@
      // @@@@@@@@@@@@@@@@@@@@@@@@,,@@@@@@@@@@@@@@@@@@@@@@@@@
      // """""""""""""""""""""""""""""""""""""""""""""""""""
      // https://textart.io/art/tag/dragon/1
      `OP_ZERO: begin alu_op  = inst[`FLD_FUNCT]; end
      default: begin alu_op  = inst[`FLD_OPCODE]; end
    endcase
    case(alu_op)
      `F_ADD:  begin
        wa = rd; ra1 = rs; ra2 = rt; reg_wen = `WREN;
        imm_ext = `IMM_ZERO_EXT; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT; end
      `ADDI:  begin
        wa = rt; ra1 = rs; ra2 = rt; reg_wen = `WREN;
        imm_ext = `IMM_ZERO_EXT; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT; end
      `ADDIU:  begin
        wa = rt; ra1 = rs; ra2 = rt; reg_wen = `WREN;
        imm_ext = `IMM_ZERO_EXT; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT; end
      `F_ADDU:  begin
        wa = rd; ra1 = rs; ra2 = rt; reg_wen = `WREN;
        imm_ext = `IMM_ZERO_EXT; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT; end
      `F_AND:  begin
        wa = rd; ra1 = rs; ra2 = rt; reg_wen = `WREN;
        imm_ext = `IMM_ZERO_EXT; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT; end
      `ANDI:  begin
        wa = rt; ra1 = rs; ra2 = rt; reg_wen = `WREN;
        imm_ext = `IMM_ZERO_EXT; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT; end
      `F_NOR:  begin
        wa = rd; ra1 = rs; ra2 = rt; reg_wen = `WREN;
        imm_ext = `IMM_ZERO_EXT; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT; end
      `F_OR:  begin
        wa = rd; ra1 = rs; ra2 = rt; reg_wen = `WREN;
        imm_ext = `IMM_ZERO_EXT; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT; end
      `ORI:  begin
        wa = rt; ra1 = rs; ra2 = rt; reg_wen = `WREN;
        imm_ext = `IMM_ZERO_EXT; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT; end
      `F_SLT:  begin
        wa = rd; ra1 = rs; ra2 = rt; reg_wen = `WREN;
        imm_ext = `IMM_ZERO_EXT; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT; end
      `SLTI:  begin
        wa = rt; ra1 = rs; ra2 = rt; reg_wen = `WREN;
        imm_ext = `IMM_ZERO_EXT; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT; end
      `SLTIU:  begin
        wa = rd; ra1 = rs; ra2 = rt; reg_wen = `WREN;
        imm_ext = `IMM_ZERO_EXT; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT; end
      `F_SLTU:  begin
        wa = rd; ra1 = rs; ra2 = rt; reg_wen = `WREN;
        imm_ext = `IMM_ZERO_EXT; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT; end
      `F_SLL:  begin
        wa = rd; ra1 = rs; ra2 = rt; reg_wen = `WREN;
        imm_ext = `IMM_ZERO_EXT; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT; end
      `F_SRL:  begin
        wa = rd; ra1 = rs; ra2 = rt; reg_wen = `WREN;
        imm_ext = `IMM_ZERO_EXT; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT; end
      `F_SUB:  begin
        wa = rd; ra1 = rs; ra2 = rt; reg_wen = `WREN;
        imm_ext = `IMM_ZERO_EXT; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT; end
      `F_SUBU:  begin
        wa = rd; ra1 = rs; ra2 = rt; reg_wen = `WREN;
        imm_ext = `IMM_ZERO_EXT; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT; end
    endcase
  end


    always @(inst) begin
      if (`DEBUG_DECODE)
        /* verilator lint_off STMTDLY */
        #1 // Delay Slightly
        $display("op = %x rs = %x rt = %x rd = %x imm = %x addr = %x, reg_wen = %x",alu_op,ra1,ra2,wa,imm,jump_addr, reg_wen);
        /* verilator lint_on STMTDLY */
    end
endmodule
