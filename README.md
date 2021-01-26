# uvm_objects_overrides
Simple program to demonstrate uvm objects override capabilities !

As UVM objects (Sequences,Sequnece items) are not part of UVM TB, we will see how we can override this in the Simple program below in different ways. 

````systemverilog
# Example 1 to have set_type_override
1) If we look at the build_phase of env we create trans of type transaction and ext_trans of type extended_transaction

trans = transaction::type_id::create("trans");
ext_trans = extended_transaction::type_id::create("ext_trans");

2) Just use the type name to override the extended_transaction with transaction

set_type_override (transaction::type_name, extended_transaction::type_name);


# Example 2 to have set_type_override from command line

1) Same as above but use +uvm_set_type_override=transaction,extended_transaction from command line and comment out the above line from test.

# Example 3 to have set_type_override_by_type

1)  Pretty much same as 1st one, add this line in the test.
set_type_override_by_type(transaction::get_type(), extended_transaction::get_type());

# Example 4 to have set_inst_override 

1) If we want to override a particular instance, first we use existing hierarchy.

Let's change this line my_env build phase to this.

trans = transaction::type_id::create("trans",this); // We are making sure 'this' belongs to env.trans

Next, we add this override in our test. Look at the string name we gave it is "env.trans" 

set_inst_override_by_type ("env.trans",transaction::get_type(),extended_transaction::get_type());

# Example 5 to have set_inst_override with absolute paths

Let's change this line my_env build phase to this.

trans = transaction::type_id::create("trans",,"welcome");

Next, we add this override in our test. Look at the string name we gave it is "welcome.trans" 

transaction::type_id::set_inst_override(extended_transaction::get_type(),"welcome.trans")

# Example 6 using command line

Using absolute path same as example 5.

+uvm_set_inst_override=transaction,extended_transaction,welcome.trans

Using existing hierachy same as example 4.

+uvm_set_inst_override=transaction,extended_transaction,uvm_test_top.env.trans




