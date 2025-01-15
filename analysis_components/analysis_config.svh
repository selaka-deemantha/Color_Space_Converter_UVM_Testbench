class analysis_config extends uvm_object;
    `uvm_object_utils   (analysis_config)
    
    
//---------------------------------------------------------------------------------------------------------------------
// Constructor
//---------------------------------------------------------------------------------------------------------------------

    function new(string name="analysis_config");
        super.new       (name);
        `uvm_info       ("[canalysis_conifg]","working",UVM_LOW);
    endfunction: new
    
endclass : analysis_config