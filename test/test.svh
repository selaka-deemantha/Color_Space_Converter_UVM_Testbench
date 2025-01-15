class test extends uvm_test;
    `uvm_component_utils(test)
    
    virtual master_if     mvif;
    virtual slave_if     svif;
    env        a_env;
    env_config      env_config_obj;

//---------------------------------------------------------------------------------------------------------------------
// Constructor
//---------------------------------------------------------------------------------------------------------------------
    
    function new(string name="test", uvm_component parent);
        super.new(name, parent);
        `uvm_info("[TEST]", "top level test constructor", UVM_LOW)
    endfunction: new

//---------------------------------------------------------------------------------------------------------------------
// Build phase
//---------------------------------------------------------------------------------------------------------------------

    function void build_phase(uvm_phase phase);
        `uvm_info("[TEST]","build_phase", UVM_LOW)

        env_config_obj  = env_config::type_id::create("env_config_obj", this);
        a_env           = env::type_id::create("a_env", this);

        if(!uvm_config_db #(virtual master_if)::get(this, "*", "mvif", mvif)) begin
            `uvm_fatal("test","No virtual interface has found");
        end
        if(!uvm_config_db #(virtual slave_if)::get(this, "*", "svif", svif)) begin
            `uvm_fatal("test","No virtual interface has found");
        end   

        env_config_obj.mvif            = mvif;
        env_config_obj.svif            = svif;

        uvm_config_db #(env_config)::set(this, "a_env", "env_configs", env_config_obj);

    endfunction: build_phase

//---------------------------------------------------------------------------------------------------------------------
// Run phase endfunction: do_compare
//---------------------------------------------------------------------------------------------------------------------   

    task run_phase(uvm_phase phase);
        sequence_m m_sequence;

        phase.raise_objection(this, "Starting uvm sequence...");

        m_sequence = sequence_m::type_id::create("m_sequence");
        fork
            m_sequence.start(a_env.m_agent.sequencer);
        join_any
        #160000ns;
        phase.drop_objection(this);
    endtask: run_phase
    
endclass: test
    