/***********************************************************************
 * A SystemVerilog RTL model of an instruction regisgter:
 * User-defined type definitions
 **********************************************************************/
package instr_register_pkg;
  //timeunit 1ns;1ns;

  typedef enum logic [3:0] { //typedef - definim tipul de date - logic: pe cati biti
  	ZERO,
    PASSA,    //ia val lui A
    PASSB,    //ia val lui B
    ADD,      //aduna valoarile
    SUB,      //scadere
    MULT,     //inmultire
    DIV,      //divizare
    MOD
  } opcode_t; //opcode_t - tip de date custom def de noi

  typedef logic signed [31:0] operand_t; //operand_t e tipul de date (signed: cu semn)
  typedef logic signed [63:0] result_t;
  
  typedef logic [4:0] address_t; //address t-tip de date
  
//urmeaza structura cu tipuri de date declarate mai sus
  typedef struct {
    opcode_t  opc;  //ne spune ce operatie vom face
    operand_t op_a; 
    operand_t op_b; //variabila
    result_t result; 

  } instruction_t; // instruction_t-un package
    //instruction_t e tot un fel de tip de date, un package care are 4 valori diferite (opc, op_a, op_b, result)

endpackage: instr_register_pkg
