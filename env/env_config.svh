class env_config extends uvm_object;
    `uvm_object_utils(env_config)
    
    //two interfaces for two agents
    virtual master_if     mvif;
    virtual slave_if     svif;
    
//---------------------------------------------------------------------------------------------------------------------
// Constructor
//---------------------------------------------------------------------------------------------------------------------
    function new(string name="env_config");
        super.new(name);
        `uvm_info("[env_config]", "working", UVM_LOW);
    endfunction: new
endclass : env_config