class master_monitor extends uvm_monitor;
    `uvm_component_utils                (master_monitor)
    virtual master_if                   mvif;
    agent_config                        agent_configuration;
    uvm_analysis_port #(seq_item_in)    a_port;

    function new(string name="master_monitor", uvm_component parent);
        super.new(name, parent);
        `uvm_info("master_monitor", "constructor", UVM_LOW);
        a_port  = new("a_port", this);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(agent_config)::get(this, "", "agent_configuration", agent_configuration)) begin
            `uvm_fatal("master_monitor", "No agent_config has found");
        end
        mvif = agent_configuration.mvif;
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        seq_item_in txn;
        bit valid;
        super.run_phase(phase);
       `uvm_info("[MONITOR]", "run_phase", UVM_HIGH)

        @(posedge this.mvif.cbm.rst_i);

        forever begin
            txn = seq_item_in::type_id::create("txn");
            collect_transaction(txn, valid);
            if(valid) begin
                a_port.write(txn);
            end
        end       
    endtask: run_phase 

    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//

    task collect_transaction (input seq_item_in txn, output bit valid);
    
        bit                         data_valid_i    = 1'b0;
        bit [7: 0]  red_i           = {8{1'b0}};
        bit [7: 0]  green_i         = {8{1'b0}};
        bit [7: 0]  blue_i          = {8{1'b0}};

        @(this.mvif.cbm);
        
        data_valid_i        = mvif.cbm.data_valid_i;
        red_i               = mvif.cbm.red_i;
        green_i             = mvif.cbm.green_i;
        blue_i              = mvif.cbm.blue_i;
        
        if(data_valid_i) begin
            txn.set_data(red_i,green_i,blue_i);
            valid = 1'b1;
            
        end
        else begin
            valid = 1'b0;
        end

    endtask: collect_transaction  

    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//



endclass: master_monitor















