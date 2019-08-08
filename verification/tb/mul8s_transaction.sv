class mul8s_transaction extends uvm_sequence_item;
    rand bit [7:0] A;
    rand bit [7:0] B;
    bit [15:0] O;
    //Alterar os dados para sua aplicação

    `uvm_object_utils_begin(mul8s_transaction)
        `uvm_field_int(A, UVM_ALL_ON|UVM_HEX)
        `uvm_field_int(B, UVM_ALL_ON|UVM_HEX)
        `uvm_field_int(O, UVM_ALL_ON|UVM_HEX)
    `uvm_object_utils_end

    function new(string name="mul8s_transaction");
        super.new(name);
    endfunction: new

    function string convert2string();
        return $sformatf("{A = %h, B = %h, O= %h}", A, B, O);
    endfunction
endclass: mul8s_transaction