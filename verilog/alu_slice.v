`include "lib/opcodes.v"
`timescale 1ns / 1ps

module ALU_SLICE
 #(parameter DLY = 10)
 (input      [`W_OPCODE-1:0]  alu_op,
  input      A, B, Cin, //Rs, Rt, Cin
  output reg R, //Rd/Rt
  output reg overflow);

  wire [2:0] add_;
  wire and_;
  wire nor_;
  wire or_;
  wire [2:0] slt_;
  wire sll_;
  wire srl_;
  wire [2:0] sub_;

  wire add_xor1, add_nand1, add_nand2;// ADD wires
  wire sub_xor1, sub_nand1, sub_nand2, sub_not1;// SUB wires
  wire and_not1;// AND wires
  wire or_not1;// OR wires

  //ADD
    // Compute Sum
    xor  #DLY ADD_G0(add_xor1,A,B);
    xor  #DLY ADD_G1(add_[0],add_xor1,Cin);
    // Compute Carry Out
    nand #DLY ADD_G2(add_nand1,add_xor1,Cin);
    nand #DLY ADD_G3(add_nand2,A,B);
    nand #DLY ADD_G4(add_[1],add_nand1,add_nand2);

  //SUB
    // Compute Sum
    not #DLY SUB_G0(sub_not1, B);
    xor  #DLY SUB_G1(sub_xor1,A,sub_not1);
    xor  #DLY SUB_G2(sub_[0],sub_xor1,Cin);
    // Compute Carry Out
    nand #DLY SUB_G3(sub_nand1,sub_xor1,Cin);
    nand #DLY SUB_G4(sub_nand2,A,sub_not1);
    nand #DLY SUB_G5(sub_[1],sub_nand1,sub_nand2);

  //SLT
    //Literlly the same as sub so we just use sub

  //AND
    //Literally just a AND (but we have to not and NAND)
    nand #DLY AND_G0(and_not1, A, B);
    not #DLY AND_G1(and_[0], and_not1);
    //Give Cout a 0 value since there is none
    assign and_[1] = 1'b0;


  //NOR
    //Literally just a NOR
    nor #DLY NOR_G0(nor_[0], A, B);
    //Give Cout a 0 value since there is none
    assign nor_[1] = 1'b0;

  //OR
    //Literally just a OR (but we have to not and NOR)
    nor #DLY OR_G0(or_not1, A, B);
    not #DLY OR_G1(or_[0], or_not1);
    //Give Cout a 0 value since there is none
    assign or_[1] = 1'b0;


  assign add_[2] = 1'b0;
  assign slt_[2] = 1'b0;
  assign sub_[2] = 1'b0;


  //Figure out hwo to do SLL and SRL
  //return full zeroes since this is done not bit by bit but fully

  //For the ones that are with immediate or unsigned, we do the same process
  //the input is different but that is on the ALU, not the alu_slice
  always @* begin
    case(alu_op)
      `ADD:  begin R = add_[0]; overflow = add_[1]; end
      `ADDI:  begin R = add_[0]; overflow = add_[1]; end
      `ADDIU:  begin R = add_[0]; overflow = add_[1]; end
      `ADDU:  begin R = add_[0]; overflow = add_[1]; end
      `AND:  begin R = and_[0]; overflow = 1'b0; end
      `ANDI:  begin R = and_[0]; overflow = 1'b0; end
      `NOR:  begin R = nor_[0]; overflow = 1'b0; end
      `OR:  begin R = or_[0]; overflow = 1'b0; end
      `ORI:  begin R = or_[0]; overflow = 1'b0; end
      `SLT:  begin R = sub_[0]; overflow = sub_[1]; end
      `SLTI:  begin R = sub_[0]; overflow = sub_[1]; end
      `SLTIU:  begin R = sub_[0]; overflow = sub_[1]; end
      `SLTU:  begin R = sub_[0]; overflow = sub_[1]; end
      `SLL:  begin R = 1'b0; overflow = 1'b0; end
      `SRL:  begin R = 1'b0; overflow = 1'b0; end
      `SUB:  begin R = sub_[0]; overflow = sub_[1]; end
      `SUBU:  begin R = sub_[0]; overflow = sub_[1]; end
      default : /*Default catch*/;
    endcase
  end

endmodule
