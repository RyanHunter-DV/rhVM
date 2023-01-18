`ifndef rhuMacros__svh
`define rhuMacros__svh

`define debug(msg) \
	`ifndef RHUDEBUG_DISABLE \
		debug.log(this.get_inst_id(),msg,`__FILE__,`__LINE__); \
	`endif


`endif
