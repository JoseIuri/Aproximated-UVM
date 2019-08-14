/*
Project           : Approximated Circuits UVM Testench
File Name         : mul8s_transaction.sv
Author            : Jose Iuri B. de Brito (XMEN LAB)
Purpose           : File that defines the main transaction of the 
                    testbench architecture.
*/


class mul8s_transaction extends uvm_sequence_item;
    rand bit signed [7:0] A;
    rand bit signed [7:0] B;
    bit signed [15:0] O;
    //Alterar os dados para sua aplicação

    `uvm_object_utils_begin(mul8s_transaction)
        `uvm_field_int(A, UVM_ALL_ON|UVM_HEX)
        `uvm_field_int(B, UVM_ALL_ON|UVM_HEX)
        `uvm_field_int(O, UVM_ALL_ON|UVM_HEX|UVM_NOCOMPARE)
    `uvm_object_utils_end

    function new(string name="mul8s_transaction");
        super.new(name);
    endfunction: new

    virtual function bit do_compare( uvm_object rhs, uvm_comparer comparer );
        mul8s_transaction that;
        real WCE;
        real WCRE;

        int error;
        int dut, rfm;
 
        if ( ! $cast( that, rhs ) ) return 0;

        // WCE% = 1.16 %
        // WCE = 759 
        // WCRE% = 1500.00 %

        rfm = this.O;
        error = that.O - this.O;
        error = (error > 0) ? error : -1*error;

        WCE = $itor(error);
        WCRE = WCE/(rfm == 0 ? 759 : rfm);
        WCRE = WCRE < 0 ? (-1)*WCRE : WCRE;

        $display("WCE = %f | WCRE = %f", WCE, WCRE);

        return (WCE <= 759 && WCRE <= 15);
   endfunction: do_compare

    function string convert2string();
        return $sformatf("{A = %d, B = %d, O= %d}", A, B, O);
    endfunction
endclass: mul8s_transaction