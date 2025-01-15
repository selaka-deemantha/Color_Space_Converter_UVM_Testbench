class master_agent extends uvm_agent;
    `uvm_component_utils                    (master_agent)
    master_driver                           driver;
    master_monitor                          monitor;   
    uvm_sequencer#(seq_item_in)             sequencer;
    agent_config                            agent_cfg;
    uvm_analysis_port#(seq_item_in)         agent_aport;


//---------------------------------------------------------------------------------------------------------------------
// Constructor
//---------------------------------------------------------------------------------------------------------------------
    
    function new(string name = "master_agent", uvm_component parent);
        super.new                           (name, parent);
        `uvm_info                           ("[UVM agent]", "constructor", UVM_HIGH)
    endfunction: new

//---------------------------------------------------------------------------------------------------------------------
// Build phase
//---------------------------------------------------------------------------------------------------------------------
    
    function void build_phase(uvm_phase phase);
        `uvm_info                           ("[UVM agent]", "build_phase", UVM_HIGH)

        if(!uvm_config_db #(agent_config)::get(this, "", "agent_configuration", agent_cfg)) begin
            `uvm_fatal("master_agent/build_phase", "");
        end
        driver                              = master_driver::type_id::create("master_driver", this);
        monitor                             = master_monitor::type_id::create("master_monitor", this);
        sequencer                           = uvm_sequencer #(seq_item_in)::type_id::create("sequence_mr", this);
        agent_aport                         = new("master_agent_port", this);

    endfunction: build_phase
    

    function void connect_phase(uvm_phase phase);
        `uvm_info                           ("AGENT", "connect_phase", UVM_HIGH)
        driver.seq_item_port.connect        (sequencer.seq_item_export);
        agent_aport                         = monitor.a_port;

    endfunction: connect_phase

    
    task run_phase(uvm_phase phase);
        super.run_phase                     (phase);

    endtask: run_phase
    

endclass: master_agent