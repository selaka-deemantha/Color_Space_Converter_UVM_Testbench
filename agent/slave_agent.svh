class slave_agent extends uvm_agent;
    `uvm_component_utils(slave_agent)

    slave_monitor                        monitor;  
    agent_config                   agent_cfg;
    uvm_analysis_port#(seq_item_out)   agent_aport;

//---------------------------------------------------------------------------------------------------------------------
// Constructor
//---------------------------------------------------------------------------------------------------------------------
    
    function new(string name = "slave_agent", uvm_component parent);
        super.new(name, parent);
        `uvm_info("[UVM agent]", "constructor", UVM_HIGH)
    endfunction: new

//---------------------------------------------------------------------------------------------------------------------
// Build phase
//---------------------------------------------------------------------------------------------------------------------
    
    function void build_phase(uvm_phase phase);
        `uvm_info("[UVM agent]", "build_phase", UVM_HIGH)

        if(!uvm_config_db #(agent_config)::get(this, "", "agent_configuration", agent_cfg)) begin
            `uvm_fatal("slave_agent/build_phase", "");
        end

        monitor     = slave_monitor::type_id::create("slave_monitor", this);

        agent_aport = new("agent_aport", this);

    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        `uvm_info("AGENT", "connect_phase", UVM_HIGH)

        agent_aport = monitor.a_port;
        
    endfunction: connect_phase
    
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask: run_phase
    
endclass: slave_agent