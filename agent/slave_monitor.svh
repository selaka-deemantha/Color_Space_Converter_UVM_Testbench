class slave_monitor extends uvm_monitor;
    `uvm_component_utils                (slave_monitor)
    virtual slave_if                    mvif;
    agent_config                        agent_configuration;
    uvm_analysis_port #(seq_item_out)   a_port;

    function new(string name="slave_monitor", uvm_component parent);
        super.new(name, parent);
        `uvm_info("slave_monitor", "constructor", UVM_LOW);
        a_port  = new("a_port", this);
    endfunction : new
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(agent_config)::get(this, "", "agent_configuration", agent_configuration)) begin
            `uvm_fatal("slave_monitor", "No agent_config has found");
        end
        mvif = agent_configuration.svif;
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        seq_item_out txn;
        bit valid;
        super.run_phase(phase);
       `uvm_info("[MONITOR]", "run_phase", UVM_HIGH)

        @(posedge this.mvif.svc.rst_i);

        forever begin
            txn = seq_item_out::type_id::create("txn", this);
            collect_transaction(txn, valid);
            if(valid) begin
                a_port.write(txn);
            end
        end       
    endtask: run_phase 

    task collect_transaction (input seq_item_out txn, output bit valid);

        bit                         data_valid_o    = 1'b0;
        bit [7:0]  y_o             = {8{1'b0}};
        bit [7:0]  cb_o            = {8{1'b0}};
        bit [7:0]  cr_o            = {8{1'b0}};

                
        @(this.mvif.svc);
        
        data_valid_o        = mvif.svc.data_valid_o;
        y_o                 = mvif.svc.y_o;
        cb_o                = mvif.svc.cb_o;
        cr_o                = mvif.svc.cr_o;

        if(data_valid_o) begin
            txn.set_data(y_o,cb_o,cr_o);
            //$display("output data from slave monitor nnn %d %d %d ",y_o, cb_o,cr_o);
            valid = 1'b1;
        end
        else begin
            valid = 1'b0;
        end
    endtask: collect_transaction 
     
endclass: slave_monitor

















