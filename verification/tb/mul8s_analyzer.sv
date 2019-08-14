class mul8s_analyzer extends uvm_component;
    `uvm_component_utils(mul8s_analyzer)
    
    mul8s_transaction tr_dut;
    mul8s_transaction tr_rm;
    uvm_analysis_imp #(uvm_built_in_pair #(mul8s_transaction), mul8s_analyzer) from_comparator;

    event begin_analyzer_task;

    int count;
    int error_count;
    real error_accumulator;
    real MAE;
    real MRE;
    real relative_accumulator;
    real squared_accumulator;
    real MSE;
    real EP;

    int transa_error_begin;
    int transa_error_end;

    function new(string name = "mul8s_analyzer", uvm_component parent);
        super.new(name, parent);
        from_comparator = new("from_comparator", this);
        count = 0;
    endfunction
    
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        error_count = 0; 
        error_accumulator = 0;
        relative_accumulator = 0;
        squared_accumulator = 0;
        transa_error_begin = 0;

        forever begin
            @begin_analyzer_task;
            if(count >= 1000) begin 
                // MAE% = 0.23 %
                // MAE = 150 
                // EP% = 93.16 %
                // MRE% = 12.26 %
                // MSE = 38236 
                error_count = (tr_rm.O == tr_dut.O) ? error_count : error_count + 1;
                EP = error_count/(2**count);
                error_accumulator = $bitstoreal(tr_rm.O-tr_dut.O) > 0 ? error_accumulator + $bitstoreal(tr_rm.O-tr_dut.O) : error_accumulator - $bitstoreal(tr_rm.O-tr_dut.O);
                MAE = error_accumulator/(2**count);
                relative_accumulator = $bitstoreal(tr_rm.O-tr_dut.O) > 0 ? relative_accumulator + ($bitstoreal(tr_rm.O-tr_dut.O)/(($bitstoreal(tr_rm.O) > 0) ? $bitstoreal(tr_rm.O) : -1*$bitstoreal(tr_rm.O))) : relative_accumulator - ($bitstoreal(tr_rm.O-tr_dut.O)/(($bitstoreal(tr_rm.O) > 0) ? $bitstoreal(tr_rm.O) : -1*$bitstoreal(tr_rm.O)));
                MRE = relative_accumulator/(2**count);
                squared_accumulator = squared_accumulator + $bitstoreal(tr_rm.O-tr_dut.O)**2;
                MSE = squared_accumulator/(2**count);

                if ((EP <= 0.9316 && MAE <= 150 && MRE <= 0.1226 && MSE <= 38236)) begin 
                    transa_error_begin = (count > transa_error_begin) ? count : transa_error_begin;
                    transa_error_end = count;
                end
            end
        end
    endtask: run_phase

    virtual function void report();
        $display("Results of Simulation");
        $display("EP     %7.2f", EP*100);
        $display("MAE     %7.2f", MAE);
        $display("MRE     %7.2f", MRE*100);
        $display("MSE     %7.2f", MSE);
        $display("");
        $display("Parameters Check Fail at Transaction %d to Transaction %d", transa_error_begin, transa_error_end);
    endfunction

    virtual function write (uvm_built_in_pair #(mul8s_transaction) t);
        tr_rm = mul8s_transaction::type_id::create("tr_rm", this);
        tr_dut = mul8s_transaction::type_id::create("tr_dut", this);
        tr_rm.copy(t.first);
        tr_dut.copy(t.second);
        count++;
        -> begin_analyzer_task;
    endfunction



endclass: mul8s_analyzer