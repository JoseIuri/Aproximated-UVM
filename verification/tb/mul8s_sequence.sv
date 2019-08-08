class mul8s_sequence extends uvm_sequence #(mul8s_transaction);
    `uvm_object_utils(mul8s_sequence)

    function new(string name="mul8s_sequence");
        super.new(name);
    endfunction: new

    task body;
        mul8s_transaction tr;

        forever begin
            tr = mul8s_transaction::type_id::create("tr");
            start_item(tr);
                assert(tr.randomize());
            finish_item(tr);
            //Alterar caso necessite de uma sequencia direcionada.
        end
    endtask: body
endclass