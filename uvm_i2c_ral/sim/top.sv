
`ifndef TOP
`define TOP
`timescale 1ns/1ns

import uvm_pkg::*;
`include "uvm_macros.svh"


//--------------------------------------------------------
//Include Files
//--------------------------------------------------------
`include "interface.sv"
`include "sequence_item.sv"
`include "reg_sequence.sv"
`include "sequencer.sv"
`include "reg_model.sv"
`include "reg_adapter.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "test_case.sv"
`include "subscriber.sv"

module top;

  logic pclk;
  logic i2c_core_clk;
  logic reset;
  intf intf(
    .i2c_core_clk(i2c_core_clk),
    .pclk(pclk)
  );

  i2c_top dut(
    .i2c_core_clk_i(intf.i2c_core_clk),
    .pclk_i(intf.pclk),
    .preset_ni(intf.preset),
    .paddr_i(intf.paddr),
    .pwrite_i(intf.pwrite),
    .psel_i(intf.psel),
    .penable_i(intf.penable),
    .pwdata_i(intf.pwdata),
    .prdata_o(intf.prdata),
    .pready_o(intf.pready),
    .reset(reset),
    .sda(intf.sda),
    .scl(intf.scl)
  );

  i2c_slave_model slave(
    .sda(intf.sda),
    .scl(intf.scl),
    .start(intf.start),
    .stop(intf.stop),
    .reset(reset),
    .data_slave_read(intf.data_slave_read),
    .data_slave_read_valid(intf.data_slave_read_valid)
  );

  initial begin
    uvm_config_db #(virtual intf)::set(null, "*", "intf", intf );
  end


  initial begin
    run_test("test");
  end

  initial begin
    i2c_core_clk = 0;
    pclk = 0;
  end

  always #10 i2c_core_clk = ~i2c_core_clk;
  always #5 pclk = ~pclk;
endmodule: top
`endif