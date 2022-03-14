/***********************************************************************
 * A SystemVerilog top-level netlist to connect testbench to DUT
 **********************************************************************/

module top;
tb_ifc intf_lab();
  //timeunit 1ns/1ns;

  // user-defined types are defined in instr_register_pkg.sv
  import instr_register_pkg::*;

  // clock variables
  logic clk;
  logic test_clk;

  // interconnecting signals
  //logic          load_en;
  //logic          reset_n;
  //opcode_t       opcode;
  //operand_t      operand_a, operand_b;
  //address_t      write_pointer, read_pointer;
  //instruction_t  instruction_word;
	
  // instantiate testbench and connect ports
  instr_register_test test (
    .clk(test_clk),
    .load_en(intf_lab.load_en),
    .reset_n(intf_lab.reset_n),
    .operand_a(intf_lab.operand_a),
    .operand_b(intf_lab.operand_b),
    .opcode(intf_lab.opcode),
    .write_pointer(intf_lab.write_pointer),
    .read_pointer(intf_lab.read_pointer),
    .instruction_word(intf_lab.instruction_word)
   );

  // instantiate design and connect ports
  instr_register dut (
    .clk(intf_lab.clk),
    .load_en(intf_lab.load_en),
    .reset_n(reset_n),
    .operand_a(intf_lab.operand_a),
    .operand_b(intf_lab.operand_b),
    .opcode(intf_lab.opcode),
    .write_pointer(intf_lab.write_pointer),
    .read_pointer(intf_lab.read_pointer),
    .instruction_word(intf_lab.instruction_word)
   );

  // clock oscillators
  initial begin //declarea inceperea codului de exec - utlizand timpi de simulare
    clk <= 0;
    forever #5  clk = ~clk; //#5, asteapta 5 unit de timp(5ns), peste 5ns clk va fi 1
  end

  initial begin
    test_clk <=0;
    // offset test_clk edges from clk to prevent races between
    // the testbench and the design
    #4 forever begin
      #2ns test_clk = 1'b1;
      #8ns test_clk = 1'b0;
    end
  end

endmodule: top
