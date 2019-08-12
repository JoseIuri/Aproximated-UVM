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
 
        if ( ! $cast( that, rhs ) ) return 0;

        // WCE% = 1.16 %
        // WCE = 759 
        // WCRE% = 1500.00 %

        WCE = $bitstoreal(that.O - this.O) >= 0 ? $bitstoreal(that.O - this.O) : $bitstoreal(this.O - that.O);
        WCRE = (this.O == 'b0 || that.O == 'b0) ?  WCE/1 : WCE/$bitstoreal(that.O);
        WCRE = WCRE < 0 ? (-1)*WCRE : WCRE;
        return (WCE <= 759 && WCRE <= 150000);
   endfunction: do_compare

    function string convert2string();
        return $sformatf("{A = %d, B = %d, O= %d}", A, B, O);
    endfunction
endclass: mul8s_transaction