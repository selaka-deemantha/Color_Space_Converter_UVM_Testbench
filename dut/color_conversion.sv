 `timescale 1ns / 1ps

module color_conversion
(
    clk,
    reset,
    data_valid_in,
    red,
    green,
    blue,
    y_out,
    cb_out,
    cr_out,
    data_valid_out
);

//---------------------------------------------------------------------------------------------------------------------
// Global constant headers
//---------------------------------------------------------------------------------------------------------------------
    

//---------------------------------------------------------------------------------------------------------------------
// parameter definitions
//---------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------------------
// localparam definitions
//---------------------------------------------------------------------------------------------------------------------    
    localparam DATA_WIDTH                       = 8;

    localparam MULT_PRECISION                   = 8;

    localparam YCBCR_DATA_BIT_INT_WIDTH         = DATA_WIDTH + MULT_PRECISION;
//---------------------------------------------------------------------------------------------------------------------
// type definitions
//---------------------------------------------------------------------------------------------------------------------


//---------------------------------------------------------------------------------------------------------------------
// I/O signals
//---------------------------------------------------------------------------------------------------------------------
    input   logic                         clk;
    input   logic                         reset; 
    input   logic                         data_valid_in;
    input   logic   [DATA_WIDTH-1:0]      red;
    input   logic   [DATA_WIDTH-1:0]      green;
    input   logic   [DATA_WIDTH-1:0]      blue;
    output  logic   [DATA_WIDTH-1:0]      y_out;
    output  logic   [DATA_WIDTH-1:0]      cb_out;
    output  logic   [DATA_WIDTH-1:0]      cr_out;
    output  logic                         data_valid_out;
//---------------------------------------------------------------------------------------------------------------------
// Internal signals
//---------------------------------------------------------------------------------------------------------------------
    logic                                            enable_converter;
    logic                                            data_valid_reg;
    logic                                            data_valid_reg_reg;
    //logic   signed  [YCBCR_DATA_BIT_INT_WIDTH-1:0]   red_int, green_int, blue_int; 
    //logic           [DATA_WIDTH-1:0]                 red_int_1, green_int_1, blue_int_1, int_1, int_2;
//-----------------------------------------------------------------------------------------------------------------
// Implementation
// //---------------------------------------------------------------------------------------------------------------------
    always_ff @(posedge clk) begin : dv_out_sync_block
        
        if(reset) begin
            data_valid_out      <= 1'b0;
            data_valid_reg      <= 1'b0;
            data_valid_reg_reg  <= 1'b0;
        end
        else begin
            if(data_valid_in) begin
                $display("red : %d  green : %d  blue : %d || y : %d  cb : %d  cr : %d",red, green, blue,y_out,cb_out,cr_out);
                data_valid_reg  <= 1'b1;
            end
            else begin
                data_valid_reg  <= 1'b0;
            end

            data_valid_reg_reg  <= data_valid_reg;
            data_valid_out      <= data_valid_reg_reg;
        end
    end

    assign enable_converter = data_valid_in | data_valid_reg | data_valid_reg_reg;
    
    converter #( .R_MULT(66),
                       .G_MULT(129),
                       .B_MULT(25),
                       .BIAS (16)) y_converter_inst_m
    (           
        .clk        (clk   ),
        .reset      (reset ),
        .enable     (enable_converter),
        .red_in     (red   ),
        .green_in   (green ),
        .blue_in    (blue  ),
        .color_out  (y_out)
    );

    converter #(   .R_MULT(-38),
                         .G_MULT(-74),
                         .B_MULT(112),
                         .BIAS (128)) cb_converter_inst_m
    (
        .clk        (clk   ),
        .reset      (reset ),
        .enable     (enable_converter),
        .red_in     (red   ),
        .green_in   (green ),
        .blue_in    (blue  ),
        .color_out  (cb_out)
    );

    converter #(         .R_MULT(112),
                         .G_MULT(-94),
                         .B_MULT(-18),
                         .BIAS (128)) cr_converter_inst_m
    (                
        .clk        (clk   ),
        .reset      (reset ),
        .enable     (enable_converter),
        .red_in     (red   ),
        .green_in   (green ),
        .blue_in    (blue  ),
        .color_out  (cr_out)
    );
endmodule