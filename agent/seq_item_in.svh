class seq_item_in extends seq_item;
    `uvm_object_utils(seq_item_in)

    bit [7:0]  data_red;
    bit [7:0]  data_green;
    bit [7:0]  data_blue;


    function new(string name = "seq_item_in");
        super.new(name);
    endfunction: new      

    function void set_data(byte data_1, byte data_2, byte data_3);
        this.data_red        = data_1;
        this.data_green      = data_2;
        this.data_blue       = data_3;
    endfunction: set_data
    
    function void get_data(output byte data_1, output byte data_2, output byte data_3);         
        data_1            = this.data_red;
        data_2          = this.data_green;
        data_3           = this.data_blue;
    endfunction: get_data



    function void my_randomize();

        data_red[7:0]   = $urandom_range(0, 255); // Random value for red component
        data_green[7:0]  = $urandom_range(0, 255); // Random value for green component
        data_blue[7:0]   = $urandom_range(0, 255); // Random value for blue component
        
    endfunction: my_randomize

    function void do_print(uvm_printer printer);
        printer.m_string = convert2string();
    endfunction : do_print
      
    function string convert2string();
        string str;
        str = "";

        $sformat(str, "Red : %0d\n", data_red);
        $sformat(str, "%sGreen : %0d\n",str, data_green);
        $sformat(str, "%sBlue : %0d\n",str ,data_blue);
        
        return str;
    endfunction: convert2string

  
    
                                    
endclass : seq_item_in


