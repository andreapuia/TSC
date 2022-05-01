/***********************************************************************
 * A SystemVerilog testbench for an instruction register; This file
 * contains the interface to connect the testbench to the design
 **********************************************************************/
interface tb_ifc (input logic clk);
  //timeunit 1ns/1ns;

  // user-defined types are defined in instr_register_pkg.sv
  import instr_register_pkg::*;

  // ADD CODE TO DECLARE THE INTERFACE SIGNALS
  logic          load_en;
  logic          reset_n;
  opcode_t       opcode;
  operand_t      operand_a, operand_b;
 // result_t       result;
  address_t      write_pointer, read_pointer;
  instruction_t  instruction_word;

  clocking cb@(clk);
               input instruction_word ;
              output load_en, reset_n, opcode, operand_a,operand_b,write_pointer, read_pointer;
endclocking;//sincronizeaza semnalele dupa un anumit clock - nu-l mai definim dupa deoarece el face mereu sincronizarea

modport TB (clocking cb); //il folosim doar ca sa apelam clocking block-ul 

endinterface: tb_ifc

