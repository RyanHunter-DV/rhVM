`ifndef rhuInterfaceDumper__svh
`define rhuInterfaceDumper__svh

class RhuInterfaceDumper_signalVector;
	logic vector[];
	int width;
	function new(int _w =1,logic[`RHUDUMPER_MAX_WIDTH-1:0] val='hx);
		width = _w;
		vector=new[width];
		foreach (vector[i]) vector[i] = val[i];
	endfunction

	extern local function logic[`RHUDUMPER_MAX_WIDTH-1:0] __vectorTobits__ ();

	function string formatted();
		logic [`RHUDUMPER_MAX_WIDTH-1:0] val=__vectorTobits__();
		string rtn = $sformatf("%0d'h%0h",width,val);
		return rtn;
	endfunction

endclass : RhuInterfaceDumper_signalVector


function logic[`RHUDUMPER_MAX_WIDTH-1:0] RhuInterfaceDumper_signalVector::__vectorTobits__(); // ##{{{
	logic[`RHUDUMPER_MAX_WIDTH-1:0] bits='h0;
	foreach (vector[i]) bits[i] = vector[i];
	return bits;
endfunction // ##}}}

class RhuInterfaceDumper;
	string name;
	UVM_FILE log;
	RhuInterfaceDumper_signalVector signals[string];
	bit initialized;

	function new (string n="<unknown>");
		name = n;
		__initDumpFile__(n);
		initialized = 1'b0;
	endfunction
	

	time current;
	// flushTimeStamp, this function will flush previous recorded signals in
	// the same time stamp into log file, and update the current time
	// also it will clear the existing signals pool
	extern function void flushTimeStamp (time _t);
	// timeChanged, compare current with input _t, if different, then return 1
	// else return 0;
	// at first time calling the record method, the timeChanged API will
	// always return 0 and record the _t to current
	extern function bit timeChanged (time _t);

	// recordNewSignalChanged, to record different signal changes from current
	// time
	extern function void recordSignalChanges (string sig,int width,logic[`RHUDUMPER_MAX_WIDTH-1:0] val);

	// close log file
	extern function void close ();

	extern function void __initDumpFile__ (string f);
endclass : RhuInterfaceDumper

function void RhuInterfaceDumper::__initDumpFile__(string f); // ##{{{
	int len = f.len();
	string ifc = f.substr(0,len-6); // (<interface hierarchy>).dump
	string headmessage = "all signals are starting with x or z value,";
	headmessage = {headmessage,"\nso if a signal that never occurred in this log means it never changed."};
	headmessage = {headmessage,"\nPlus, this dumper only records signals whose value changed at a different simtime"};
	log = $fopen(f,"w");
	$fdisplay(log,"ATTENTION: %s",headmessage);
	$fdisplay(log,"");
	$fdisplay(log,"INTERFACE HIERARCHY: %s",ifc);
	$fdisplay(log,"");
	$fdisplay(log,"TIME SIGNAL VALUE");
	return;
endfunction // ##}}}

function void RhuInterfaceDumper::close(); // ##{{{
	$fclose(log);
endfunction // ##}}}

function void RhuInterfaceDumper::recordSignalChanges(string sig,int width,logic[`RHUDUMPER_MAX_WIDTH-1:0] val); // ##{{{
	RhuInterfaceDumper_signalVector newSig = new(width,val);
	if (signals.exists(sig)) begin
		string _recordVal = signals[sig].formatted();
		string _changedVal= newSig.formatted();
		`uvm_warning("ZTC",$sformatf("zero time change happened for signal:%s",sig))
		`uvm_info("ZTC",$sformatf("recorded value(%s),changed value(%s)",_recordVal,_changedVal),UVM_MEDIUM)
		return;
	end

	signals[sig] = newSig;

endfunction // ##}}}

function bit RhuInterfaceDumper::timeChanged(time _t); // ##{{{
	if (!initialized) begin current = _t;initialized=1; end
	if (current != _t) return 1;
	return 0;
endfunction // ##}}}

function void RhuInterfaceDumper::flushTimeStamp(time _t); // ##{{{
	string logline = "";
	//DEBUG, $display($time,", flushing signals to log");
	foreach (signals[sig]) begin
		logline = $sformatf("%0f %0s -> %0s",current,sig,signals[sig].formatted());
		//DEBUG, $display("DEBUG: log item: %0s",logline);
		$fdisplay(log,logline);
	end
	current = _t; // update current time
	signals.delete(); // need clear
	//DEBUG, $display($time,", siglas deleted, array size: %0d",signals.size());
endfunction // ##}}}

`endif
