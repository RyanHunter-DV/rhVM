# Overview
## command description
- [[#rhload]], loading other utb files
- [[#clock]], specify clocks for this testbench
- 

# Example
## typical example
*source*
```top.utb
project 'TestProject'
clock 'tbClk',100#,:mhz, default is mhz, so no need to specify it
clock 'refClk',1,:ghz
reset 'tbResetn','tbClk',0,'100ns'
interface 'RhAhb5If','mIf'
dut 'DUTModule',:as=>'udut' do
	connect(
		'iClk'=>'tbClk'
	)
end
```
*target*
```top.sv
module top;
	ClockGenIf clockIf();
	ResetGenIf resetIf(clockIf.oClk[1]);
	initial begin
		uvm_config_db#(virtual ClockGenIf)::set(null,"*","clockIf",clockIf);
		uvm_config_db#(virtual ResetGenIf)::set(null,"*",xxx)
	end

	initial run_test();
	initial $fsdb_dump...
	
endmodule
	
	
```


# APIs
## rhload
this used to load all other configurations such as env.utb, test.utb etc. This typically established at the top line of the top.utb file.

## clock
Defined in the [[#Top]] class:
`+ clock : nil (name,freq,unit)`
This API will add clock generator to the Top class, according to different clock uvc set by user, can generate different SV code.

*steps*:
```
def clock ...
	@clock = @@ClockUVC.new if @clock==nil;
	@clock.addClock('clockname',freq,:unit);
```
*ClockUVC*
```
class MyClockUVC < ...
	def addClock ...
		# user specific code
	def getClock name
		return @realnames[name];
	def declare ...
		return @svcode[:declare]
	def intfDeclare
		return @intf.svcode[:declare]
	def intfConfigSet
		return @intf.svcode[:configSet]
```
## reset


## interface
`+ interface : nil (name,inst,ports)`
*step*:
```
def interface ...
	intf = SVInterface.new(name)
	intf.ports(ports) # ports= 'HCLK,HRESETN'
	@intfs << intf;
```
class details: [[#SVInterface]]
## dut
defined in [[#Top]] class.
`+ dut : nil (module,:as=>inst,block)`
This will create a `SVModule` named `module`, and set its inst name to `inst`. Then eval the block within the `SVModule`, like:
*call*:
```
dut 'DUTModule',:as=>'udut' do
	connect(
		'iClk'=>'tbClk'
	)
end
```
*exe*:
```
m = SVModule.new(module)
m.setInst(inst)
m.instance_eval(block)
```

# Classes
## Top
The top class which all `*.utb` will be evaluated.
### attributes
### methods
- [[#clock]]
- [[#dut]]

## SVInterface
A ruby class declares behaviors for interface.
