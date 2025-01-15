class seq_item extends uvm_sequence_item;
    `uvm_object_utils(seq_item)
    


    function new(string name = "seq_item");
        super.new(name);
    endfunction: new      

    virtual function void set_data(byte data_1, byte data_2, byte data_3);
    endfunction

    virtual function void get_data(output byte data_1, output byte data_2, output byte data_3);
    endfunction
    
    virtual function void do_print(uvm_printer printer);
    endfunction
      
    virtual function string convert2string();
    endfunction
       
    virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    endfunction

endclass : seq_item