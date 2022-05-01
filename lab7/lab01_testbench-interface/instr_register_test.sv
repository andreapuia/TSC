/***********************************************************************
 * A SystemVerilog testbench for an instruction register.
 * The course labs will convert this to an object-oriented testbench
 * with constrained random test generation, functional coverage, and
 * a scoreboard for self-verification.
 **********************************************************************/

//interfata : virtual tb_ifc.TB intf_lab 
import instr_register_pkg::*;
 
 
class First_test;
  virtual tb_ifc.TB intf_lab ; // declararea interfatei in clasa#
  //intf_lab asta trebuie sa fie la fel cu cel din top
  parameter generate_numberofoperation=600;


 covergroup my_coverage;
    OPERAND_A_COVER: coverpoint  intf_lab.cb.operand_a //OPA_COVER este o eticheta
      {
        bins op_a_values_neg[]={[-15:-1]}; //am pus parantezele patrate ca sa ne poata lua toate valoriile din interval - facem un vector
        bins op_a_values_0={0};
        bins op_a_values_poz[]={[1:15]};
      }
     OPERAND_B_COVER: coverpoint  intf_lab.cb.operand_b
      {
        bins op_b_values_0={0};
        bins op_b_values_poz[]={[1:15]};
      }
       OPERAND_OPCODE_COVER: coverpoint  intf_lab.cb.opcode
      {
        bins op_opcode_values[]={[0:7]};
      }  
      OPERAND_RESULT_COVER: coverpoint intf_lab.cb.instruction_word.result
      {
        bins result_values_neg[] = {[-225:-1]};
        bins result_values_zero = {0};
        bins result_values_pos[] = {[1:225]};
      }
  endgroup
    
  function new( virtual tb_ifc.TB interfata_functie );
    intf_lab =interfata_functie; // constructorului ii dam interfata
    my_coverage=new();
    //interfata_functiei- este parametrul iar intf_lab  este interfata noastra 
  endfunction: new
  //int seed = 555; //valoare initiala cu care se incepe randomiazrea
  
  //initial begin //block unde lucram cu semnalele - e un task (initial-begin)
  task run();
    $display("\n\n***********************************************************");
    $display(    "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(    "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(    "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(    "************************FIRST HEADER***********************");
    $display(    "***********************************************************");

    $display("\nReseting the instruction register...");
    intf_lab.cb.write_pointer  <= 5'h00;         // initialize write pointer
    intf_lab.cb.read_pointer   <= 5'h1F;         // initialize read pointer
    intf_lab.cb.load_en        <= 1'b0;          // initialize load control line
    intf_lab.cb.reset_n        <= 1'b0;          // assert reset_n (active low)
    repeat (2) @(posedge intf_lab.cb) ;     // hold in reset for 2 clock cycles
    intf_lab.cb.reset_n        <= 1'b1;          // deassert reset_n (active low)

    $display("\nWriting values to register stack...");
    @(posedge intf_lab.cb)intf_lab.cb.load_en <= 1'b1;  // enable writing to register
    //repeat (7) begin
      repeat (generate_numberofoperation) begin
      @(posedge intf_lab.cb) randomize_transaction;
      @(negedge intf_lab.cb) print_transaction;
      my_coverage.sample();
    end
    @(posedge intf_lab.cb) intf_lab.cb.load_en <= 1'b0;  // turn-off writing to register

    // read back and display same three register locations
    $display("\nReading back the same register locations written...");
    //for (int i=0; i<=2; i++) begin
    //  // later labs will replace this loop with iterating through a
    //  // scoreboard to determine which addresses were written and
    //  // the expected values to be read back
    //  @(posedge intf_lab.cb.clk) intf_lab.cb.read_pointer <= i;
    //  @(negedge intf_lab.cb.clk) print_results;
    //end
       for (int i=0; i<=generate_numberofoperation; i++) begin
      // later labs will replace this loop with iterating through a
      // scoreboard to determine which addresses were written and
      // the expected values to be read back
      @(posedge intf_lab.cb) intf_lab.cb.read_pointer <= i;
      @(negedge intf_lab.cb) print_results;
       my_coverage.sample();
      end

    @(posedge intf_lab.cb) ;
    $display("\n***********************************************************");
    $display(  "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(  "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(  "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(  "***********************************************************\n");
    $finish;
  //end
  endtask

  function void randomize_transaction; //FUNCTIA ARE TIMP DE SIMULARE0 - TASK POATE CONTINE TIMP DE SIMULARE  (IN TASK POTI PUNE INSTRUCTIUNI CARE CONSUMA TIMP)
    // A later lab will replace this function with SystemVerilog
    // constrained random values
    //
    // The stactic temp variable is required in order to write to fixed
    // addresses of 0, 1 and 2.  This will be replaceed with randomizeed
    // write_pointer values in a later lab
    //
    static int temp = 0;
   //intf_lab.cb.operand_a     <= $random(seed)%16;                 // between -15 and 15
   //intf_lab.cb.operand_b     <= $unsigned($random)%16;            // between 0 and 15
   //intf_lab.cb.opcode        <= opcode_t'($unsigned($random)%8);  // between 0 and 7, cast to opcode_t type //CAST-TRECE DIN INDEX IN STRING
    intf_lab.cb.operand_a     <= $signed($urandom())%16;                       // between -15 and 15 //urandom genereaza numere pe 32 de biti %16-aduce valoare intre -199 si 1999
    intf_lab.cb.operand_b     <= $unsigned($urandom)%16;            // between 0 and 15
    intf_lab.cb.opcode        <= opcode_t'($unsigned($urandom)%8);  // between 0 and 7, cast to opcode_t type //CAST-TRECE DIN IND
    intf_lab.cb.write_pointer <= temp++;
  endfunction: randomize_transaction

  function void print_transaction; //FUNCTIA PRINTEAZA IN TRANSCRIPT VALORILE 
    $display("Writing to register location %0d: ", intf_lab.cb.write_pointer);
    $display("  opcode = %0d (%s)", intf_lab.cb.opcode, intf_lab.cb.opcode.name);
    $display("  operand_a = %0d",  intf_lab_new.cb.operand_a);
    $display("  operand_b = %0d\n", intf_lab.cb.operand_b);
    //$display("  result = %0d\n", intf_lab.cb.result);
    $display("  Time = %dns", $time());
  endfunction: print_transaction

  function void print_results;
    $display("Read from register location %0d: ", intf_lab.cb.read_pointer);
    $display("  opcode = %0d (%s)", intf_lab.cb.instruction_word.opc, intf_lab.cb.instruction_word.opc.name);
    $display("  operand_a = %0d",   intf_lab.cb.instruction_word.op_a);
    $display("  operand_b = %0d\n", intf_lab.cb.instruction_word.op_b);
    $display("  Result = %0d\n", intf_lab.cb.instruction_word.result);
    $display("  Time =  %dns", $time());
    //adaug result
  endfunction: print_results
endclass 

module instr_register_test(  tb_ifc.TB intf_lab);
    // user-defined types are defined in instr_register_pkg.sv
  
 // input  logic          clk,
 //  output logic          load_en,
 //  output logic          reset_n,
 //  output operand_t      operand_a,
 //  output operand_t      operand_b,
 //  output operand_r      result,
 //  output opcode_t       opcode,
 //  output address_t      write_pointer,
 //  output address_t      read_pointer,
 //  input  instruction_t  instruction_word
 
  //timeunit 1ns/1ns;

  initial begin
    First_test fs_test;
    fs_test=new(intf_lab); //adaugam interfata si o apelam  de aici direct, fara sa mai facem inca o linie suplimentara :fs_test.Laborator2_new=Laborator2_new;
    //fs_test.intf_lab=intf_lab;
    fs_test.run(); // apelarea task-ului creat mai jos
  end

endmodule: instr_register_test


//random stabila pe thread si urandom stabila pe clase

//clasa - tot in afar de initial-begin intra intr-o clasa : functii, task-uri, interfata si variabile interne ( ex seed)