import rhudbg::*;
`include "intf.sv"
module top;
	Intf uif();

	initial begin
		run_test("baseTest");
	end
endmodule
