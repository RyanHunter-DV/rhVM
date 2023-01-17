`ifndef rhuMacros__svh
`define rhuMacros__svh

`define debug(msg) \
	debug.log(this.get_inst_id(),msg,`__FILE__,`__LINE__);

`endif
