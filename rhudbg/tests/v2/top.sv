`include "uvm_macros.svh"
import uvm_pkg::*;
import rhudbg::*;
import envPkg::*;
`include "intf.sv"
module top;
	logic clk,rstn;
	Intf uif(clk,rstn);

	initial begin
		clk = 0;rstn=0;
		#100ns;
		rstn=1;
	end
	always #4ns clk <= ~clk;

	//initial begin
	//	uvm_config_db:#(virtual Intf)::set(null,"*","Intf",uif);
	//end

	initial begin
		#3ns;
		$display($time,", driving signal");
		uif.HWDATA<='h20;
		uif.HTRANS<='h2;
		@(posedge clk);
		$display($time,", driving signal");
		uif.HWDATA<=$urandom;
		uif.HTRANS<=3;
		repeat (10) @(posedge clk);
		$display($time,", driving signal");
		uif.HWDATA<=$urandom;
		uif.HTRANS<=0;
		repeat (20) @(posedge clk);
		$display($time,", driving signal");
		uif.HWDATA <= 'h3x2;
		uif.HTRANS <= 'h0;
	end

	initial begin
		run_test();
	end
endmodule
