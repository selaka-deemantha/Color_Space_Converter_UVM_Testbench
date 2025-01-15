interface slave_if(
    input                       clk,
    input                       rst_i
);


    wire                        data_valid_o;
    wire [7 :0]    y_o;
    wire [7 :0]    cb_o;
    wire [7 :0]    cr_o;

   
    clocking svc @(posedge clk); 

        input                   data_valid_o;
        input                   y_o;
        input                   cb_o;
        input                   cr_o;
        input                   rst_i;

    endclocking



endinterface: slave_if