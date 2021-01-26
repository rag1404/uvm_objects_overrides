// transaction which extends uvm_object and has 3 fields

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  program tb;

  // Simple transaction which has 3 fields data,addr,wr_en
  class transaction extends uvm_object; 
    rand bit[3:0] data;
    rand bit[5:0] addr;
    rand bit wr_en;

    `uvm_object_utils_begin(transaction);
    `uvm_field_int(data,UVM_ALL_ON)
    `uvm_field_int(addr,UVM_ALL_ON)
    `uvm_field_int(wr_en,UVM_ALL_ON)
    `uvm_object_utils_end;


    function new (string name  = "transaction");
      super.new(name);
    endfunction  

  endclass

// extended_transaction is derived from transaction and has a additional field extended_addr

    class extended_transaction extends transaction;
      rand bit [3:0] extended_addr;

      `uvm_object_utils_begin(extended_transaction);
      `uvm_field_int(extended_addr,UVM_ALL_ON)
     `uvm_object_utils_end;

      function new (string name  = "extended_transaction");
      super.new(name);
      endfunction  

    endclass

// A env to create two transactions and randomize it

    class my_env extends uvm_env;
    `uvm_component_utils(my_env)


   transaction trans;
   extended_transaction ext_trans;   

    function new (string name = "my_env", uvm_component parent=null);
      super.new(name,parent);
    endfunction

     function void build_phase(uvm_phase phase);
       trans = transaction::type_id::create("trans");
       ext_trans = extended_transaction::type_id::create("ext_trans");

    endfunction

      task run_phase (uvm_phase phase);
        void'(trans.randomize());
      `uvm_info(get_type_name(),$sformatf(" tranaction randomized"),UVM_LOW)
      trans.print();
        `uvm_info(get_type_name(),$sformatf(" tranaction printing from my_env"),UVM_LOW)
     #10;
      endtask

    endclass

// A base_test to put our overrides

    class base_test extends uvm_test;

    `uvm_component_utils(base_test)


    my_env env;



    function new(string name = "base_test",uvm_component parent=null);
      super.new(name,parent);
    endfunction : new


     function void build_phase(uvm_phase phase);
       
      
      uvm_factory factory = uvm_factory::get();
       super.build_phase(phase);
      env = my_env::type_id::create("env", this);
      set_type_override_by_type(transaction::get_type(), extended_transaction::get_type());
      factory.print();  
    endfunction : build_phase


     function void end_of_elaboration();
     print();
     endfunction

    virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      #500;
      phase.drop_objection(this);
    endtask

  endclass : base_test



    initial begin
      run_test("base_test");  
    end  

  endprogram
