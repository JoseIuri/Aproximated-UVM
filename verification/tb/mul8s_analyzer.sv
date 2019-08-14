class mul8s_analyzer extends uvm_component;
    `uvm_component_utils(mul8s_analyzer)
    
    mul8s_transaction tr_dut;
    mul8s_transaction tr_rm;
    uvm_analysis_imp #(uvm_class_pair #(mul8s_transaction, mul8s_transaction), mul8s_analyzer) from_comparator;

    event begin_analyzer_task;

    int count;
    real error_count;
    real error_accumulator;
    real MAE;
    real MRE;
    real relative_accumulator;
    real squared_accumulator;
    real MSE;
    real EP;

    real error;
    int error_int;
    int rfm;

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
            // MAE% = 0.23 %
            // MAE = 150 
            // EP% = 93.16 %
            // MRE% = 12.26 %
            // MSE = 38236 

            rfm = tr_rm.O;

            error_int = tr_dut.O - tr_rm.O;
            error_int = (error_int > 0) ? error_int : -1*error_int;
            error = $itor(error_int);

            error_count = (error == 0) ? error_count : error_count + 1;
            EP = error_count/(count);
            error_accumulator = error_accumulator + error;
            MAE = error_accumulator/(count);
            relative_accumulator = (rfm == 0) ? relative_accumulator : relative_accumulator + error/rfm;
            MRE = relative_accumulator/(count);
            squared_accumulator = squared_accumulator + (error**2);
            MSE = squared_accumulator/(count);

            if(count >= 1000) begin 
                if ((EP <= 0.9316 && MAE <= 150 && MRE <= 0.1226 && MSE <= 38236)) begin 
                    transa_error_begin = (count > transa_error_begin) ? count : transa_error_begin;
                    transa_error_end = count;
                end
            end
        end
    endtask: run_phase

    virtual function void report();
        $display("\n\n");
        $display("--- Results of Simulation Outputs --- \n\n");
        $display("EP:     %7.2f", EP*100);
        $display("MAE:     %7.2f", MAE);
        $display("MRE:     %7.2f", MRE*100);
        $display("MSE:     %7.2f", MSE);
        $display("");
        $display("Parameters Check Fail at Transaction %d to Transaction %d", transa_error_begin, transa_error_end);
    endfunction

    virtual function write (uvm_class_pair #(mul8s_transaction, mul8s_transaction) t);
        tr_rm = mul8s_transaction::type_id::create("tr_rm", this);
        tr_dut = mul8s_transaction::type_id::create("tr_dut", this);
        tr_rm.copy(t.first);
        tr_dut.copy(t.second);
        count++;
        -> begin_analyzer_task;
    endfunction



endclass: mul8s_analyzer