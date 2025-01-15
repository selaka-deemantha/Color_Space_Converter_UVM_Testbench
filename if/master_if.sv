interface master_if(
    input                       clk,
    input                       rst_i
);

    wire                        data_valid_i;
    wire [7 :0]    red_i;
    wire [7 :0]    green_i;
    wire [7 :0]    blue_i;


   
    // master driver clocking block
    clocking cbmd @(posedge clk); 


        output                  data_valid_i;
        output                  red_i;
        output                  green_i;
        output                  blue_i;
        input                   rst_i;
    endclocking

    // monitor clocking block
    clocking cbm @(posedge clk); 

        input                   data_valid_i;
        input                   red_i;
        input                   green_i;
        input                   blue_i;
        input                   rst_i;

    endclocking

endinterface: master_if