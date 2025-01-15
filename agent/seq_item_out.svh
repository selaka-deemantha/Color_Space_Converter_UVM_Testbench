class seq_item_out extends seq_item;
    `uvm_object_utils(seq_item_out)

    bit [7:0]  data_y;
    bit [7:0]  data_cb;
    bit [7:0]  data_cr;


    function new(string name = "seq_item_out");
        super.new(name);
    endfunction: new      

    function void set_data(byte data_1, byte data_2, byte data_3);
        this.data_y         = data_1;
        this.data_cb        = data_2;
        this.data_cr        = data_3;
    endfunction: set_data
    
    function void get_data(output byte data_1, output byte data_2, output byte data_3);         
        data_1              = this.data_y;
        data_2             = this.data_cb;
        data_3             = this.data_cr;
    endfunction: get_data

    function void do_print(uvm_printer printer);
        printer.m_string = convert2string();
    endfunction : do_print
      
    function string convert2string();
        string str;
        str = "";

        $sformat(str, "\nY : %0d\n", data_y);
        $sformat(str, "%sCb : %0d\n",str ,data_cb);
        $sformat(str, "%sCr : %0d\n",str, data_cr);
        
        return str;
    endfunction: convert2string


    function bit compare_with_tolerance(
        bit [7:0] expected_value, actual_value
    );
        bit eq = 1'b1;

        real error;
        real error_epsilon = 3;

        error = (expected_value > actual_value) ? (expected_value - actual_value) : (actual_value - expected_value);

        if (error <= error_epsilon) begin
            eq = 1'b1;
        end else begin
            eq = 1'b0;
        end
        return eq;
    endfunction:compare_with_tolerance

    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        seq_item_out tr;
        bit eq = 1'b1;

        // Cast rhs to seq_item_out
        if (!$cast(tr, rhs)) begin
            `uvm_fatal("FTR", "Illegal do_compare cast")
        end

        // Compare the fields using the comparer
        //compare_field("used to store and print miscompare", lhs object, rhs object, number of bits to compare)
        eq &= compare_with_tolerance(data_y, tr.data_y);
        eq &= compare_with_tolerance(data_cb, tr.data_cb);
        eq &= compare_with_tolerance(data_cr, tr.data_cr);

        return eq;
    endfunction: do_compare


                                    
endclass : seq_item_out


