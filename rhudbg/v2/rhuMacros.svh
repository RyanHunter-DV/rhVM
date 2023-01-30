`ifndef rhuMacros__svh
`define rhuMacros__svh

`define debug(msg) \
	`ifndef RHUDBG_DISABLE \
		debug.log(this.get_inst_id(),msg,`__FILE__,`__LINE__); \
	`endif

`define debugCall(extMsg,line) \
	`ifndef RHUDBG_DISABLE \
		begin \
			string _local_msg = {`"line`",", ",extMsg}; \
			`debug($sformatf("calling %s",_local_msg)) \
			line; \
		end \
	`else \
		line; \
	`endif

`endif
