The architecture of the utb-v1.

# procedures
- load MainEntry, for processing user options
- create Top class, and eval within the Top class

# process top.utb
The top.utb specifies all configurations within all testbench scope. So the top.utb is being executed within a Top class in ruby, all others are being created within the Top class.

# User Options
## override the VIP setup procedures
#TBD 

# Classes
## Component
`class Component`
It's a base class for Ruby, which can be extended as a clock, vip etc. It provides:
### attributes
`# name`, name of this component
### methods
`# alias : string (string='')`
if arg is a valid string, then to set this component's alias name, else to return current alias name.
## ClockUVC < Component
A clock uvc class derived from Component
`ClockGen_v1 < ClockUVC`
Users can customize their own clock uvc by deriving a new class and call:
`setup 'clock',ClockGen_v1` #TBD 


## ResetUVC < Component

## SVModule < Component
*features*
- connection, the instantiate information
- inst, the instance name
### attribute

### methods
`+ connect : nil (Hash)`
called while instantiating the SVModule, like:
```
m = SVModule.new('inst');
m.instance_eval do
	connect(
		'iClk'=>'tbClk',
		'iRstn'=>'tbResetn'
	)
end
```
