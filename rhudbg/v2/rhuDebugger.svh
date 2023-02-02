`ifndef rhuDebugger__svh
`define rhuDebugger__svh

class RhuDebugger extends uvm_report_object;

	string rootPath;
	local bit __enabled__ = 1'b0;
	local bit registerPool[uvm_object];
	
	// uvm_component comps[$];
	// `uvm_object_utils(RhuDebugger)

	// - each time when this class is newed, first to check the static
	// enabledObjs,
	// is current obj.get_type_name() included in enabledObjs?
	// if included, record to logfile[obj.inst_id] = obj.full_inst_path+".log"
	// call m_rh.set_id_file("RHUDBG"+inst_id) and m_rh.set_id_action
	function new(uvm_object obj);
		string name = $sformatf("%s.RhuDebugger",obj.get_name());
		uvm_component comp;
		super.new(name);
		if (!$cast(comp,obj)) begin
			uvm_report_fatal("RHUDBG-FATAL","RhuDebugger can only be setup by a component",UVM_NONE,`__FILE__,`__LINE__);
		end
		__setup__;
	endfunction
	
	extern local function void __setup__();
	// log debug information into specific log file
	// to call uvm_report_info with id: "RHUDBG"+obj.inst_id
	extern function void log (uvm_object obj,string msg,string file,int line);

	// current object is enabled by command line, to setup its action/file and
	// if is a component, need to setup all its children
	extern function void __setupObjFileAndActions__ (uvm_object obj);

	extern function void enable ();
	extern function bit registered (uvm_object obj);
	extern local function void __registerObject__ (uvm_object obj);
endclass

function bit RhuDebugger::registered(uvm_object obj); // ##{{{
	if (registerPool.exists(obj)) return 1;
	return 0;
endfunction // ##}}}

function void RhuDebugger::__registerObject__(uvm_object obj); // ##{{{
	registerPool[obj] = 1;
	__setupObjFileAndActions__(obj);
endfunction // ##}}}

function void RhuDebugger::enable(); // ##{{{
	__enabled__ = 1;
endfunction // ##}}}
function void RhuDebugger::__setupObjFileAndActions__(uvm_object obj); // ##{{{
	// setup current object
	string id = $sformatf("RHUDBG-%0d",obj.get_inst_id());
	UVM_FILE file=$fopen($sformatf("%s/%s.log",rootPath,obj.get_full_name()),"w");
	// debug disabled, $display($time,", set_id_file, id(%s) => file(%s.log)",id,obj.get_full_name());
	m_rh.set_id_file(id,file);
	m_rh.set_id_action(id,UVM_LOG);
	return;
endfunction // ##}}}

function void RhuDebugger::log(uvm_object obj,string msg,string file,int line); // ##{{{
	string id = $sformatf("RHUDBG-%0d",obj.get_inst_id());
	if (__enabled__) begin
		if (!registered(obj)) __registerObject__(obj);
		uvm_report_info(id,msg,UVM_LOW,file,line,"",0);
	end
	return;
endfunction // ##}}}

function void RhuDebugger::__setup__(); // ##{{{
	rootPath = "./logs";
	$system($sformatf("mkdir -p %s",rootPath));
endfunction // ##}}}

`endif
