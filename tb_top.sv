`timescale 1ns/1ns
import uvm_pkg::*;
`include "uvm_macros.svh"

import env_pkg::*;
import test_pkg::*;

module tb_top;
  
    localparam HALF_CLK_PERIOD  = 5;

    logic clk;
    logic rst_i;

    master_if mvif (
        .clk            (clk                        ),
        .rst_i          (rst_i                      )
    );

    slave_if svif (
        .clk            (clk                         ),
        .rst_i          (rst_i                       )
    );

    color_conversion dut(
        .clk            (clk                        ),
        .reset          (rst_i                      ),
        .data_valid_in  (mvif.data_valid_i),
        .red            (mvif.red_i       ),
        .green          (mvif.green_i     ),
        .blue           (mvif.blue_i      ),
        .data_valid_out (svif.data_valid_o),
        .y_out          (svif.y_o         ),
        .cb_out         (svif.cb_o        ),
        .cr_out         (svif.cr_o        )
    );


    initial begin
        clk     = 1'b1;
        forever begin
            #HALF_CLK_PERIOD clk = ~clk;
        end
    end

    initial begin
        rst_i   = 1'b0;
        #(HALF_CLK_PERIOD);
        rst_i   = 1'b1;
        #(3*HALF_CLK_PERIOD);
        rst_i   = 1'b0;
    end

    initial begin
        uvm_config_db #(virtual master_if)::set(null, "*", "mvif", mvif);
        uvm_config_db #(virtual slave_if)::set(null, "*", "svif", svif);
        run_test();
        
    end
endmodule: tb_top











   


