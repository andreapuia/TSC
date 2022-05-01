/***********************************************************************
 * A SystemVerilog top-level netlist to connect testbench to DUT
 **********************************************************************/

module top;
  //timeunit 1ns/1ns;

  // user-defined types are defined in instr_register_pkg.sv
  import instr_register_pkg::*;

  // clock variables
  logic clk;
  logic test_clk;

	tb_ifc intf_lab (clk); //am importat interfata - am creat o instanta pentru interfata
  // interconnecting signals
  //logic          load_en;
  //logic          reset_n;
  //opcode_t       opcode;
  //operand_t      operand_a, operand_b;
  //address_t      write_pointer, read_pointer;
  //instruction_t  instruction_word;
  
//logic          load_en;
 // logic          reset_n;
  //opcode_t       opcode;
  //operand_t      operand_a, operand_b;
  //address_t      write_pointer, read_pointer;
  //instruction_t  instruction_word;

  // instantiate testbench and connect ports
  instr_register_test test (.intf_lab(intf_lab ));//.intf_lab -este firul pe care il folosim mai departe si care contine 
   // .clk(test_clk),
    //.load_en(intf_lab.load_en),
    //.reset_n(intf_lab.reset_n),
    //.operand_a(intf_lab.operand_a),
    //.operand_b(intf_lab.operand_b),
    //.opcode(intf_lab.opcode),
    //.write_pointer(intf_lab.write_pointer),
    //.read_pointer(intf_lab.read_pointer),
    //.instruction_word(intf_lab.instruction_word)


  // instantiate design and connect ports
  instr_register dut (
    .clk(clk),
    .load_en(intf_lab.load_en),
    .reset_n(intf_lab.reset_n),
    .operand_a(intf_lab.operand_a),
    .operand_b(intf_lab.operand_b),
    //.result(intf_lab.result),
    .opcode(intf_lab.opcode),
    .write_pointer(intf_lab.write_pointer),
    .read_pointer(intf_lab.read_pointer),
    .instruction_word(intf_lab.instruction_word)
   );

  // clock oscillators
  initial begin
    clk <= 0;
    forever #5  clk = ~clk; //#5- odata la 5 unitati de timp clk se neaga
  end

  initial begin
    test_clk <=0;
    // offset test_clk edges from clk to prevent races between
    // the testbench and the design
    #4 forever begin //asteapta 4 unitati de timp inainte sa intre in forever 
      #2ns test_clk = 1'b1;
      #8ns test_clk = 1'b0;
    end
  end

endmodule: top
