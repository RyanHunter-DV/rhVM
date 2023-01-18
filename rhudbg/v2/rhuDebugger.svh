`ifndef rhuDebugger__svh
`define rhuDebugger__svh

class RhuDebugger extends uvm_report_object;

	// static RhuDebugger inst = RhuDebugger::getDebugger();
	static bit initialized = 1'b0;
	static string enabledObjs[$];
	
	// uvm_component comps[$];
	// `uvm_object_utils(RhuDebugger)

	// - each time when this class is newed, first to check the static
	// enabledObjs,
	// is current obj.get_type_name() included in enabledObjs?
	// if included, record to logfile[obj.inst_id] = obj.full_inst_path+".log"
	// call m_rh.set_id_file("RHUDBG"+inst_id) and m_rh.set_id_action
	function new(uvm_object obj,string T);
		string name = $sformatf("%s.RhuDebugger",obj.get_name());
		super.new(name);
		if (initialized==0) setup;
		if (__objEnabled__(obj.get_type_name())) begin
			__setupObjFileAndActions__(obj,T);
		end
	endfunction

	
	extern static function void setup();
	// user command example:
	// +RHUDBG=<Component0>,<Component1> or
	// +RHUDBG=<Component0>
	// - recognize those options, and store to a static table
	extern static local function void __setupCommandOptions__ ();

	// log debug information into specific log file
	// to call uvm_report_info with id: "RHUDBG"+obj.inst_id
	extern function void log (int instID,string msg,string file,int line);

	// current object is enabled by command line, to setup its action/file and
	// if is a component, need to setup all its children
	extern function void __setupObjFileAndActions__ (uvm_object obj,string T);

	// check the given typename is in the enable list or not
	extern function bit __objEnabled__ (string typename);
	extern function string __removeParams__ (string src);
endclass

function string RhuDebugger::__removeParams__(string src); // ##{{{
	string raw = src;
	int len = src.len();
	for (int pos=0;pos<len;pos++) begin
		if (src[pos]=="#") begin
			raw = src.substr(0,pos-1);
			break;
		end
	end
	return raw;
endfunction // ##}}}

function bit RhuDebugger::__objEnabled__(string typename); // ##{{{
	string rawtype = __removeParams__(typename);
	$display($time,", searching for objEnabled, typename(%s)",rawtype);
	foreach (enabledObjs[i]) begin
		if (enabledObjs[i]==rawtype) return 1;
	end
	return 0;
endfunction // ##}}}

function void RhuDebugger::__setupObjFileAndActions__(uvm_object obj,string T); // ##{{{
	// setup current object
	string id = $sformatf("RHUDBG-%0d",obj.get_inst_id());
	UVM_FILE file=$fopen($sformatf("%s.log",obj.get_full_name()),"w");
	$display($time,", set_id_file, id(%s) => file(%s.log)",id,obj.get_full_name());
	m_rh.set_id_file(id,file);
	m_rh.set_id_action(id,UVM_LOG);
	if (T=="component") begin
		uvm_component children[$];
		uvm_component comp;
		$cast(comp,obj);
		comp.get_children(children);
		foreach (children[i])
			this.__setupObjFileAndActions__(children[i],"component");
	end
	return;
endfunction // ##}}}

function void RhuDebugger::__setupCommandOptions__(); // ##{{{
	string option;
	int len;
	int spos=0;
	$value$plusargs("RHUDBG=%s",option);
	len = option.len();
	if (len<=0) return;
	if (option[len-1]!=",") begin
		option = {option,","};
		len++;
	end
	for (int pos=0;pos<len;pos++) begin
		if (option[pos]==",") begin
			enabledObjs.push_back(option.substr(spos,pos-1));
			spos = pos+1;
		end
	end
	// debug
	foreach (enabledObjs[i]) $display("enabledObjs[%0d] => %s",i,enabledObjs[i]);
endfunction // ##}}}
function void RhuDebugger::log(int instID,string msg,string file,int line); // ##{{{
	string id = $sformatf("RHUDBG-%0d",instID);
	uvm_report_info(id,msg,UVM_LOW,file,line,"",1); // force report
endfunction // ##}}}

function void RhuDebugger::setup(); // ##{{{
	__setupCommandOptions__;
	initialized = 1'b1;
endfunction // ##}}}

`endif
