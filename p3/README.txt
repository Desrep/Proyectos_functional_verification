Testbench for the verification of a SDR SDRAM controller
The architecture of this testbench is based on
https://verificationguide.com/uvm/uvm-testbench-architecture/ especially for the boilerplate code
Evertying has been modified and expanded to work with this more complex DUV
It has 3 agents, 2 passive and one active connected to the scoreboard using 3 ports
It decodes the addresses and verifies data is correct usign a model for the memory
the seq_item has the necessary constraints for the  devices to work,
the test checks most of the possible configurations, this Testbench works for all the 3 widths supported
for the SDRAMS 8bits, 16bits and 32 bits.
The configuration includes the SDRAM config register, this register is controlled via the interface
and the checkers are based on the documentation for the DUV.
The DUV can be found in https://opencores.org/
