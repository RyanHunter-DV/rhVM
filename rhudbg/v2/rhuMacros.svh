`ifndef rhuMacros__svh
`define rhuMacros__svh

`define RHUDUMPER_MAX_WIDTH 2048

`define rhudbg(msg) \
	`ifndef RHUDBG_DISABLE \
		config.debug.log(this,msg,`__FILE__,`__LINE__); \
	`endif

`define rhudbgCall(extMsg,expr) \
	`ifndef RHUDBG_DISABLE \
		`rhudbgCall_guard(extMsg,expr,`__LINE__) \
	`else \
		expr; \
	`endif

`define rhudbgLine(extMsg,expr) \
	`ifndef RHUDBG_DISABLE \
		`rhudbgLine_guard(extMsg,expr) \
	`else \
		expr; \
	`endif
`define rhudbgLine_guard(extMsg,expr) \
	begin \
		string _local_msg = {`"expr`",", ",extMsg}; \
		`rhudbg($sformatf("executing %s",_local_msg)) \
		expr; \
	end

`define rhudbgCall_guard(extMsg,expr,line) \
	begin \
		RhuCaller _caller = RhuCaller::getGlobal(); \
		string _local_msg = {`"expr`",", ",extMsg}; \
		_caller.stack(`__FILE__,line); \
		`rhudbg($sformatf("calling %s",_local_msg)) \
		expr; \
	end

`define caller0(file,line) \
	`ifndef RHUDBG_DISABLE \
		`caller0_guard(file,line) \
	`else \
		file = "RHUDBG DISABLED"; \
		line = 0; \
	`endif

`define caller0_guard(file,line) \
	begin \
		RhuCaller _callerTmp = RhuCaller::getGlobal(); \
		_callerTmp.caller(0,file,line); \
	end

`define rhuLogicSignal(var,width) \
	logic [width-1:0] var; \
	`ifndef RHUDBG_DISABLE \
		`rhuLogicSignal_guard(var,width) \
	`endif

`define rhuLogicSignal_guard(var,width) \
	always @(var) rhudbg::RhuDumper::record($sformatf("%m.dump"),`"var`",width,var,$time);

`define rhuDumperPostProcess \
	`ifndef RHUDBG_DISABLE \
		final rhudbg::RhuDumper::postProcess($sformatf("%m.dump")); \
	`endif


`endif
