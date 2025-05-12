# Multi-cycle CPU design

## Custom 16-bit CPU in VHDL  
This project implements a simple 16-bit processor architecture using VHDL. It includes a control unit, datapath, ALU, register file, memory modules, and testbenches.

## System Architecture  
The CPU fetches, decodes, and executes instructions from program memory. It supports arithmetic and logic operations, branching, and memory load/store instructions.

Main components:
- **Control.vhd**: Finite state machine generating control signals
- **Datapath.vhd**: Connects ALU, registers, and memory
- **ALU.vhd**: Performs arithmetic and logic operations
- **RF.vhd**: 16-register bank with read/write support
- **ProgMem / DataMem**: Instruction and data storage

## Features  
- 16-bit instruction and data width  
- Sign-extended immediate operands  
- 4-bit opcode with support for: ADD, SUB, MOV, AND, OR, XOR, JMP, JC, JNC  
- Separate program and data memory  
- Bidirectional shared data bus (BUS_A / BUS_B)
- 
## Simulation Instructions  
1. Open the project in ModelSim / Vivado / GHDL  
2. Compile all VHDL files from the `src` directory  
3. Run testbenches in `tb/` to simulate specific modules  
4. Observe waveform and verify functional correctness


# FA.vhd  
This module implements a 1-bit Full Adder that receives two input bits and a carry-in, and produces a sum and carry-out. 

# AdderSub.vhd  
This module performs either addition or subtraction between two input vectors X and Y, based on the control signal sub_cont. When sub_cont = '0', the module computes Y + X. When sub_cont = '1', it computes Y - X using 2’s complement arithmetic. The result is stored in the output vector res, and the output bit Cout is set to '1' in case of a carry, and '0' otherwise.

# ALU.vhd  
This module implements a basic Arithmetic Logic Unit (ALU) with support for various operations based on a 4-bit function selector (ALUFN). It receives two operands via BUS_A and BUS_B. The first operand is latched into an internal register RegA when Ain='1' on a rising clock edge. The ALU performs operations such as pass-through (B), addition (A+B), subtraction (A-B), bitwise AND, OR, and XOR. The output is driven back onto BUS_A, and status flags (Cflag, Zflag, Nflag) are updated accordingly.

# BidirPin.vhd
This module implements a bidirectional tristate buffer. When the enable signal (en) is '1', the output Dout is driven onto the IOpin bus. When en is '0', the IOpin bus is placed in high-impedance state ('Z'), effectively disconnecting the output. This is useful for shared buses where only one driver should be active at a time.

# Control.vhd
This module implements the control unit of the processor using a finite state machine (FSM). It generates all necessary control signals for data path components, such as memory access, register file, immediate inputs, and ALU operation based on the current instruction and status flags. The FSM transitions between states like fetch, decode, execution, load, store, jump, and done, while determining the next state and setting outputs such as ALUFN, PCsel, and write-enable signals accordingly.

# dataMem.vhd
This module implements a synchronous read/write data memory block. It defines an internal RAM array (sysRAM) and allows writing data to it when memEn='1' on a rising clock edge. Simultaneously, it outputs the value at address RmemAddr to RmemData. The module uses address and data widths defined by generics and converts addresses from std_logic_vector to integers for array indexing.

# Datapath.vhd
This module implements the main datapath of the processor, connecting all functional units including the program memory, data memory, instruction register, register file, ALU, and several multiplexers and tri-state buffers. It coordinates instruction fetch, decode, and execution based on control signals. The datapath includes sign extension logic for immediate values, a PC register for program flow, and manages reading/writing from/to memory. It also supports testbench inputs via TBactive and allows bidirectional bus sharing through BidirPin modules. Control over internal state is achieved using decoded opcodes, enabling execution of arithmetic, logic, memory, and branch instructions.

# IR.vhd
This module implements the Instruction Register (IR). On the rising edge of the clock, if the control signal IRin is high, the module captures the instruction data from PM_dataOut and stores it in an internal register (IRreg). The current instruction is then continuously output through IR_Reg. A report statement is also used to print the instruction value for simulation debugging.

# OPC_Decoder.vhd
This module decodes a 4-bit operation code (OPC) into one-hot control signals corresponding to processor instructions. Based on the value of OPC, it activates exactly one of the output signals such as st, ld, mov, done, add, sub, jmp, jc, jnc, and, or, xor. Each output is asserted high '1' only if the OPC matches the specific instruction code, and otherwise remains low '0'. This enables control logic to identify and execute the correct instruction.

# PC_Register.vhd
This module implements the program counter (PC) logic for instruction fetching. It updates the PC value on the rising clock edge when PCin is high. The next PC value is selected based on the PCsel signal: "00" increments the PC by 1, "01" adds an immediate offset from the instruction register (IR) to the incremented PC (used for jumps), and otherwise resets it to zero. The result is assigned to the output readAddr, which provides the address to fetch the next instruction from program memory. Two internal adders compute PC+1 and PC+1+IR.

# ProgMem.vhd
This module implements a synchronous program memory with separate read and write access. It contains an internal RAM array that stores 16-bit instructions. On the rising clock edge, if memEn is high, a new instruction word (WmemData) is written to the address specified by WmemAddr. At the same time, the memory outputs the instruction at the address RmemAddr through RmemData, enabling instruction fetch by the program counter.

# RF.vhd
This module implements a register file with one read port and one write port. It contains an array of registers, each Dwidth bits wide. On reset, register 0 is initialized to zero. On the rising edge of the clock, if WregEn is high, the value WregData is written into the register specified by WregAddr. Simultaneously, the contents of the register at RregAddr are continuously output on RregData. The module uses conv_integer to convert std_logic_vector addresses to integers for indexing.

# top.vhd
This is the top-level module that connects the Control unit and the Datapath of the processor. It defines the main system ports and internal signals, and instantiates both the Control and Datapath entities. The Control unit receives instruction decoding and flag inputs and generates control signals such as ALUFN, register or memory enables, and selection signals. The Datapath performs instruction execution, memory access, and ALU operations. The top module integrates program and data memory interfaces and supports testbench inputs for simulation and debugging through TBactive, ITCM_tb_wr, and DTCM_tb_wr.

# aux_package.vhd  
This package includes the declarations of all the components used across the project, allowing for cleaner and more modular code. 
