`ifndef rhuMacros__svh
`define rhuMacros__svh

`define debug(msg) \
	`ifndef RHUDBG_DISABLE \
		debug.log(this.get_inst_id(),msg,`__FILE__,`__LINE__); \
	`endif

`define debugCall(extMsg,expr) \
	`ifndef RHUDBG_DISABLE \
		`debugCall_guard(extMsg,expr,`__LINE__) \
	`else \
		expr; \
	`endif

`define debugLine(extMsg,expr) \
	`ifndef RHUDBG_DISABLE \
		`debugLine_guard(extMsg,expr) \
	`else \
		expr; \
	`endif
`define debugLine_guard(extMsg,expr) \
	begin \
		string _local_msg = {`"expr`",", ",extMsg}; \
		`debug($sformatf("executing %s",_local_msg)) \
		expr; \
	end

`define debugCall_guard(extMsg,expr,line) \
	begin \
		RhuCaller _caller = RhuCaller::getGlobal(); \
		string _local_msg = {`"expr`",", ",extMsg}; \
		_caller.stack(`__FILE__,line); \
		`debug($sformatf("calling %s",_local_msg)) \
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


`endif
