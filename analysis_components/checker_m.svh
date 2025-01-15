class checker_m extends uvm_scoreboard;
    `uvm_component_utils(checker_m)

    uvm_analysis_export     #(seq_item_out)         predictor_export;
    uvm_analysis_export     #(seq_item_out)         master_export;
    uvm_in_order_class_comparator #(seq_item_out)   comparator;

    function new(string name="checker_m",uvm_component parent);
        super.new(name,parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        predictor_export      = new("predictor_export", this);
        master_export         = new("master_export", this   );

        comparator            = uvm_in_order_class_comparator #(seq_item_out)::type_id::create("comparator", this);

    endfunction: build_phase


    virtual function void connect_phase(uvm_phase phase);
        //comparator checks first transaction in before_export port and after_export port
        //connect the predictor port to comparator before export port
        predictor_export.connect  (comparator.before_export );

        //connect the master monitor port to comparator after export port
        master_export.connect     (comparator.after_export  );

    endfunction: connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);


        forever begin
             #(100);
            $display("comparator.m_mismatches %d", comparator.m_mismatches  );
            $display("comparator.m_matches %d", comparator.m_matches        );
            if(comparator.m_mismatches > 0) begin
                $fatal(1,"Error_code : found_mismatches");
            end
        end
    endtask : run_phase
    
endclass: checker_m
