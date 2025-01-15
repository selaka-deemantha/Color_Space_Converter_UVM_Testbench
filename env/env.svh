class env extends uvm_env;
    `uvm_component_utils(env)

    env_config          env_configs;

    master_agent        m_agent;
    slave_agent         s_agent;

    checker_m           a_checker_m;
    predictor           a_predictor;

//---------------------------------------------------------------------------------------------------------------------
// Constructor
//---------------------------------------------------------------------------------------------------------------------   

    function new(string name="env", uvm_component parent);
        super.new(name, parent);
        `uvm_info("[ENV]", "constructor", UVM_LOW);
    endfunction: new

//---------------------------------------------------------------------------------------------------------------------
// Build phase
//---------------------------------------------------------------------------------------------------------------------
     
    function void build_phase(uvm_phase phase);
        agent_config       m_agent_config;
        agent_config       s_agent_config;
        analysis_config    analysis_cfg;   

        super.build_phase(phase);

        //create agents
        m_agent    = master_agent::type_id::create("m_agent", this);
        s_agent    = slave_agent::type_id::create("s_agent", this);

        //create analysis components
        a_checker_m       = checker_m::type_id::create("checker_m", this);
        a_predictor     = predictor::type_id::create("predictor", this);

        //create configuration objects for agents
        m_agent_config  = agent_config::type_id::create("m_agent_config", this);
        s_agent_config  = agent_config::type_id::create("s_agent_config", this);

        analysis_cfg    = analysis_config::type_id::create("analysis_cfg", this);

        //get environment configs
        if(!uvm_config_db #(env_config)::get(this, "", "env_configs", env_configs)) begin
            `uvm_fatal("[env]", "cannot find configs")
        end

        //set master agent configs
        m_agent_config.mvif        = env_configs.mvif;

        //set slave agent configs
        s_agent_config.svif        = env_configs.svif;

        //set analysis component configs

        uvm_config_db #(agent_config)::set(this, "m_agent*", "agent_configuration", m_agent_config);
        uvm_config_db #(agent_config)::set(this, "s_agent*", "agent_configuration", s_agent_config);
        uvm_config_db #(analysis_config)::set(this, "predictor*", "analysis_cfg", analysis_cfg);
    endfunction: build_phase

//---------------------------------------------------------------------------------------------------------------------
// Connect phase
//---------------------------------------------------------------------------------------------------------------------

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        m_agent.agent_aport.connect(a_predictor.analysis_export);

        a_predictor.expected_aport.connect(a_checker_m.predictor_export);

        s_agent.agent_aport.connect(a_checker_m.master_export);
        
    endfunction: connect_phase

//---------------------------------------------------------------------------------------------------------------------
// Run phase
//---------------------------------------------------------------------------------------------------------------------

    task run_phase(uvm_phase phase);
        `uvm_info("[ENV]", "run_phase", UVM_LOW)
    endtask: run_phase
    
endclass: env