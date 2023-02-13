This is generation 1 of the Unit Level Testbench Builder.
# Use Cases

## cmd call
```
src/verif/env/env.utb
src/verif/tb/top.utb
-----------------------
>> utb -i path/top.utb -o src/verif
```

## top.utb
the top file configures the whole testbench related configurations.
- rhload, loads the other configurations such as setup of topEnv, tests etc.
- project, specify the project name.
- clock, specify the clock generator
- reset, specify the reset generator
- interface, declare all interfaces connected with DUT
- dut, specify the instance of a dut
details in:[[doc/utb/v1/top.utb]]

## env.utb
specify the unit env, which will be the real env of a wrapper env named 'topEnv', which is for all level envs.
- unit env setup and configurations supported.
- base test setup and configurations supported.



## test.utb
to configure all tests.

# Document Content
- [[doc/utb/v1/architecture]]
- [[doc/utb/v1/top.utb]]


