mkfile_path := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

# - Change UVM_HOME if u have a different path

QUESTA_HOME ?= /home/selaka/intelFPGA/23.1std/questa_fse

# - Change UVM_HOME if u have a different path
UVM_HOME ?=$(QUESTA_HOME)/verilog_src/uvm-1.2/

VSIM            ?= vsim
VSIM_FLAGS	= -gLOAD_L2=JTAG
VSIM_SUPPRESS   = -suppress vsim-3009 -suppress vsim-8683 -suppress vsim-8386

VLOG            ?= vlog \
					-timescale "1ns/1ns" \
					+define+UVM_NO_DPI \
					-suppress 8303 \
					-reportprogress 300 \
					-64 \
					-incr \
					-mfcu \
					-sv \
					-writetoplevels questa.tops \
					+incdir+$(UVM_HOME)/src \
					$(UVM_HOME)/src/uvm.sv 
VLOG_FLAGS      =

VOPT            ?= vopt
VOPT_FLAGS      ?= +acc

VLIB            ?= vlib work
VMAP            ?= vmap

# top-level (tesbench)/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
SIM_TOP     ?= tb_top
DUT         ?= color_conversion
TEST_NAME	?= test
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

MODE 		?= -c

.PHONY: show_test_list
## List all uvm tests 
show_test_list:
	@echo "#######################################################"
	@echo "##############  UVM TEST LIST  ########################"
	@echo "#######################################################"
	@cd uvm_tb/test/ && \
	ls | grep .svh
	# ls *.svh | sed 's/\.[^.]*$//'
	@echo "#######################################################"
	@echo "Note : use TEST_NAME without .svh extension"

## Compile RTL with Questasim
all:build run

.PHONY: run
run: build
	$(VSIM) $(MODE) -64 vopt_tb \
	-suppress 8303 \
	+UVM_TESTNAME=$(TEST_NAME) \
	-do sim.do 

.PHONY: build
build: compile opt

.PHONY: opt
opt: compile
	$(VOPT) $(VOPT_FLAGS) -o vopt_tb $(SIM_TOP) -work work 

.PHONY: vlib
vlib: 
	$(VLIB)

.PHONY: compile
compile: vlib
		$(VLOG) \
		+incdir+./if \
		+incdir+./agent \
		+incdir+./analysis_components \
		+incdir+./env \
		+incdir+./test \
		+incdir+./dut \
		./if/master_if.sv \
		./if/slave_if.sv \
		./agent/agent_pkg.sv \
		./analysis_components/analysis_components_pkg.sv \
		./env/env_pkg.sv \
		./test/test_pkg.sv \
		./dut/converter.sv \
		./dut/$(DUT).sv \
		./$(SIM_TOP).sv
		
	
.PHONY: clean
## Remove all compiled RTL
clean:
	$(RM) -r work 
	$(RM) modelsim.ini
	$(RM) questa.tops
	$(RM) vsim_stacktrace.vstf
	$(RM) vsim.wlf

	