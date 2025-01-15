class sequence_m extends uvm_sequence #(seq_item_in);
    `uvm_object_utils(sequence_m)

    function new(string name="sequence_m");
        super.new(name);
    endfunction: new

    task body();
        seq_item_in    txn;
        txn = seq_item_in::type_id::create("txn");

        repeat (300) begin
            start_item(txn);
            txn.my_randomize();
            finish_item(txn);
        end
    endtask: body
endclass : sequence_m