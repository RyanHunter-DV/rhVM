`include "uvm_macros.svh"
import uvm_pkg::*;
import rhudbg::*;
import envPkg::*;
`include "intf.sv"
module top;
	Intf uif();

	initial begin
		run_test();
	end
endmodule
