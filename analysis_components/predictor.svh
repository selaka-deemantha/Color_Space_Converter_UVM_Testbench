class predictor extends uvm_subscriber#(seq_item_in);
    `uvm_component_utils(predictor)

    uvm_analysis_port   #(seq_item_out)     expected_aport;

    
    function new(string name="predictor", uvm_component parent);
        super.new(name, parent);
        expected_aport  = new("expected_aport", this);
        
    endfunction : new

      task run_phase(uvm_phase phase);
        
    endtask: run_phase 

    virtual function void write(seq_item_in t);
        seq_item_out   txn;

        bit [7:0] data_red;
        bit [7:0] data_green;
        bit [7:0] data_blue;

        bit [7:0] data_y;
        bit [7:0] data_cb;
        bit [7:0] data_cr;

        txn = seq_item_out::type_id::create("txn");

        t.get_data(data_red, data_green, data_blue);

        data_y   = (16  + (66* data_red + 129 * data_green + 25 * data_blue ) / 256);
        data_cb  = (128 - (38 * data_red + 74 * data_green - 112 * data_blue) / 256);
        data_cr  = (128 + (112 * data_red - 94 * data_green - 18 * data_blue) / 256);

        txn.set_data(data_y, data_cb, data_cr);

        expected_aport.write(txn);
    endfunction: write


endclass : predictor
