class master_driver extends uvm_driver#(seq_item_in);
    `uvm_component_utils                                (master_driver)
    virtual master_if                                   mvif;
    agent_config                                        agent_configuration;


    function new(string name="master_driver", uvm_component parent);
        super.new                                       (name, parent);
    endfunction: new


    function void build_phase(uvm_phase phase);
        super.build_phase                               (phase);
        if(!uvm_config_db #(agent_config)::get(this, "*", "agent_configuration", agent_configuration)) begin
            `uvm_fatal("master_driver", "No agent_configuration has found");
        end 
        mvif                                            = agent_configuration.mvif;       
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase                             (phase);
    endfunction: connect_phase

    task run_phase(uvm_phase phase);
        seq_item_in                                     txn;
        super.run_phase                                 (phase);

        @(this.mvif.cbmd);
        //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
        mvif.cbmd.data_valid_i                          <= 0;                                                                                                                        
        mvif.cbmd.red_i                                 <= 0;                                                        
        mvif.cbmd.green_i                               <= 0;                                                        
        mvif.cbmd.blue_i                                <= 0;                                                        
        
        //****************************************************************************************//

        @(posedge this.mvif.cbmd.rst_i);
        
        forever begin
            txn                                         = seq_item_in::type_id::create("txn");
            seq_item_port.get_next_item                 (txn);
            txn_transfer                                (txn);
            seq_item_port.item_done                     ();
        end
    endtask: run_phase

    
    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
    task txn_transfer(seq_item_in txn);
        bit [7:0]  data_red;                                                           
        bit [7:0]  data_green;                                        
        bit [7:0]  data_blue;                                                 
      
        txn.get_data(data_red, data_green, data_blue);                         
                                                                                             
        @(this.mvif.cbmd);                                                          
        mvif.cbmd.data_valid_i     <= 1'b1;
        mvif.cbmd.red_i            <= data_red;
        mvif.cbmd.green_i          <= data_green;
        mvif.cbmd.blue_i           <= data_blue;
        
    endtask: txn_transfer
    //****************************************************************************************//

    
endclass: master_driver


    






























