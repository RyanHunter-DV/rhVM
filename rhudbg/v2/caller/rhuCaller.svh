`ifndef rhuCaller__svh
`define rhuCaller__svh

class RhuCaller;

	static RhuCaller mInst;

	string fileStack[$];
	int    lineStack[$];

	function new ();
	endfunction

	extern static function RhuCaller getGlobal ();
	
	// APIs
	// stack, push file/line information into stack
	extern function void stack (string file,int line);

	// caller, to get the stacked file and line information
	extern function void caller (int lvl,ref string file,ref int line);
endclass : RhuCaller

function void RhuCaller::caller(int lvl,ref string file,ref int line); // ##{{{
	if (lvl!=0) begin
		$display("warning: caller not support level > 0");
		return; // caller not support level > 0
	end

	if (fileStack.size()<=0) begin
		$display("error: caller called without any debugCall !!!");
		return;
	end

	file = fileStack.pop_back();
	line = lineStack.pop_back();

	return;
endfunction // ##}}}

function void RhuCaller::stack(string file,int line); // ##{{{
	fileStack.push_back(file);
	lineStack.push_back(line);
endfunction // ##}}}

function RhuCaller RhuCaller::getGlobal(); // ##{{{
	if (mInst==null) mInst=new();
	return mInst;
endfunction // ##}}}

`endif
