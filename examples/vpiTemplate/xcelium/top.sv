module top;

	int ia;
	logic ib;


	initial begin
		ia = $urandom_range(0,20000);
		$display("ia in sv: %0d",ia);
		$svcMain();
	end

	logic clk;
	initial begin
		clk = 1'b0;
	end

	initial begin
		#50ns;
		ia = $urandom_range(0,1000);
		$display($time,", value(SV): %0d",ia);
		#200ns;
		$finish;
	end

	always #5ns clk<= ~clk;


endmodule
