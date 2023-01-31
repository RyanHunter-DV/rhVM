`ifndef rhuDumper__svh
`define rhuDumper__svh


class RhuDumper;

	static RhuInterfaceDumper idumpPool[string];
	
	function new ();
	endfunction

	extern static function void record (string log,string sig,int width,logic[`RHUDUMPER_MAX_WIDTH-1:0] val,time _t);
	extern static function void postProcess (string log);
endclass : RhuDumper

function void RhuDumper::postProcess(string log); // ##{{{
	foreach (idumpPool[log]) begin
		idumpPool[log].flushTimeStamp($time);
		idumpPool[log].close(); // close log
		// call script to rearrange the log files
		// TODO, $system($sformatf("rhuDumperPostProcess.rb %s",log));
	end
endfunction // ##}}}

function void RhuDumper::record(
	string log,
	string sig,
	int width,
	logic[`RHUDUMPER_MAX_WIDTH-1:0] val,
	time _t
); // ##{{{
	RhuInterfaceDumper idump;
	if (idumpPool.exists(log)) idump = idumpPool[log];
	else begin
		//DEBUG, $display($time,", new idump created, log: %s",log); // DEBUG
		idump = new(log);
		idumpPool[log] = idump;
	end

	if (idump.timeChanged(_t)) idump.flushTimeStamp(_t);
	//DEBUG, $display($time,",record signals: %s, %0d, %0h",sig,width,val); // DEBUG
	idump.recordSignalChanges(sig,width,val);

endfunction // ##}}}




`endif
