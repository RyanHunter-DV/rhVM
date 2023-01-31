interface Intf(input logic HCLK,input logic HRESETn);

	`rhuLogicSignal(HWDATA,32)
	`rhuLogicSignal(HTRANS,2)
	`rhuLogicSignal(HBURST,2)
	`rhuLogicSignal(HMSTLOCK,1)


	`rhuDumperPostProcess

endinterface
