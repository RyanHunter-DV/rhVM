`ifndef rhuMacros__svh
`define rhuMacros__svh

`define debug(msg) \
	`ifndef RHUDBG_DISABLE \
		debug.log(this.get_inst_id(),msg,`__FILE__,`__LINE__); \
	`endif

`define debugCall(extMsg,line) \
	`ifndef RHUDBG_DISABLE \
		begin \
			string msg = {`"line`",", ",extMsg}; \
			`debug($sformatf("calling %s",msg)) \
			line; \
		end \
	`else \
		line; \
	`endif

`endif
