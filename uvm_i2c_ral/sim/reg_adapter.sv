`ifndef REG_ADAP
`define REG_ADAP
class reg_adapter extends uvm_reg_adapter;
    `uvm_object_utils(reg_adapter)
    function new (string name = "reg_adapter");
        super.new (name);
    endfunction

    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        packet pkt;
        pkt = packet::type_id::create("pkt");
        pkt.pdata = rw.data;
        pkt.paddr = rw.addr;
        pkt.pwrite = rw.kind == UVM_WRITE;
        if (rw.kind == UVM_WRITE)
            `uvm_info(get_name(), $sformatf("Write %0h to register %0h", pkt.pdata, pkt.paddr), UVM_LOW)
        return pkt;
    endfunction

    virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        packet pkt; 
        assert ($cast(pkt, bus_item));
        rw.kind = pkt.pwrite ? UVM_WRITE : UVM_READ;
        rw.data = pkt.pdata;
        rw.addr = pkt.paddr;
        rw.status = UVM_IS_OK; 
    endfunction
endclass
`endif