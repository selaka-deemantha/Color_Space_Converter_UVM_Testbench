class agent_config extends uvm_object;
    `uvm_object_utils(agent_config)

    virtual master_if       mvif;
    virtual slave_if        svif;

    
    function new(string name="agent_config");
        super.new           (name);
        `uvm_info           ("[agent_config]", "constructor", UVM_LOW);
    endfunction: new

endclass: agent_config