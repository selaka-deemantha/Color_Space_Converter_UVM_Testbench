`timescale 1ns / 1ps

module converter
(
    clk,
    reset,
    enable,
    red_in,
    green_in,
    blue_in,
    color_out
);

//---------------------------------------------------------------------------------------------------------------------
// Global constant headers
//---------------------------------------------------------------------------------------------------------------------
    

//---------------------------------------------------------------------------------------------------------------------
// parameter definitions
//---------------------------------------------------------------------------------------------------------------------
    parameter                                  DATA_WIDTH                = 8;
    parameter                                  MULT_PRECISION            = 8;
   
    parameter    signed    [MULT_PRECISION:0]  R_MULT                    = 66;  // 65.738 
    parameter    signed    [MULT_PRECISION:0]  G_MULT                    = 129; // 129.057 
    parameter    signed    [MULT_PRECISION:0]  B_MULT                    = 25;  // 25.064      
    
    parameter              [DATA_WIDTH-1:0]    BIAS                      = 128;
//---------------------------------------------------------------------------------------------------------------------
// localparam definitions
//---------------------------------------------------------------------------------------------------------------------    
    localparam                                 YCBCR_DATA_BIT_INT_WIDTH  = DATA_WIDTH + MULT_PRECISION + 1;
//---------------------------------------------------------------------------------------------------------------------
// type definitions
//---------------------------------------------------------------------------------------------------------------------


//---------------------------------------------------------------------------------------------------------------------
// I/O signals
//---------------------------------------------------------------------------------------------------------------------
    input   logic                          clk; 
    input   logic                          reset;
    input   logic                          enable;       
    input   logic    [DATA_WIDTH-1:0]      red_in;
    input   logic    [DATA_WIDTH-1:0]      green_in;
    input   logic    [DATA_WIDTH-1:0]      blue_in;
    output  logic    [DATA_WIDTH-1:0]      color_out;
 
//---------------------------------------------------------------------------------------------------------------------
// Internal signals
//---------------------------------------------------------------------------------------------------------------------
    logic   signed   [YCBCR_DATA_BIT_INT_WIDTH-1:0]   red_int, green_int, blue_int; 
    logic   signed   [DATA_WIDTH-1:0]                 red_int_1, green_int_1, blue_int_1, int_1, int_2;
    
    logic   signed   [DATA_WIDTH:0]                   red_a;
    logic   signed   [DATA_WIDTH:0]                   green_a;
    logic   signed   [DATA_WIDTH:0]                   blue_a;
//--------------------------------------------------------------------------------------------------------------------
// Implementation
// //---------------------------------------------------------------------------------------------------------------------
    
    assign  red_int_1       = red_int[YCBCR_DATA_BIT_INT_WIDTH-1:MULT_PRECISION];
    assign  green_int_1     = green_int[YCBCR_DATA_BIT_INT_WIDTH-1:MULT_PRECISION];
    assign  blue_int_1      = blue_int[YCBCR_DATA_BIT_INT_WIDTH-1:MULT_PRECISION]; 
    
    assign  red_a           = {1'b0, red_in};
    assign  green_a         = {1'b0, green_in};
    assign  blue_a          = {1'b0, blue_in};
  
    always_ff @(posedge clk) begin : converter_block
        if(reset) begin
            color_out      <= {DATA_WIDTH{1'd0}};
            red_int        <= 0;
            green_int      <= 0;
            blue_int       <= 0;
            int_1          <= 0;
            int_2          <= 0;
        end   
        else begin 
            if(enable) begin
                red_int    <= R_MULT * red_a;
                green_int  <= G_MULT * green_a;
                blue_int   <= B_MULT * blue_a;

                int_1      <= BIAS + red_int_1;
                int_2      <= blue_int_1 + green_int_1;
                color_out  <= int_1 + int_2;
            end
        end
    end
endmodule