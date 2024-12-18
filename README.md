#  Final Project of Reti Logiche (year: 2022-2023)

## Project Overview

This project involves implementing a hardware module in VHDL that interfaces with memory and routes data to one of four output channels based on specific input constraints.

## Project Specifications

### System Description
- Implements a hardware module that receives memory location and channel routing instructions
- Processes input via a single-bit serial input
- Outputs data in parallel across four 8-bit channels

## Key Components

### Input Interfaces
- Clock (CLK)
- Reset (RESET)
- Start Signal (START)
- Serial Input (W)

### Output Interfaces
- Four 8-bit Output Channels (Z0, Z1, Z2, Z3)
- Done Signal (DONE)
- Memory Address Output
- Memory Enable/Write Enable Signals

## Input Data Format

### Channel Identification
- First 2 bits determine output channel:
  - `00`: Z0
  - `01`: Z1
  - `10`: Z2
  - `11`: Z3

### Address Specification
- Address can be 0-16 bits long
- Addresses less than 16 bits are zero-padded on the most significant bits
- All memory addresses are 16 bits wide

## Operational Constraints

### Timing Restrictions
- START signal must remain high for 2-18 clock cycles
- Maximum processing time: Less than 20 clock cycles
- DONE signal active for only one clock cycle

### Reset and Initialization
- Initial state: All channels (Z0-Z3) set to 0
- DONE signal initially 0
- Reset initializes the module for the first START signal

## Interface Entity

```vhdl
entity project_reti_logiche is
port (
    i_clk : in std_logic;
    i_rst : in std_logic;
    i_start : in std_logic;
    i_w : in std_logic;
    o_z0 : out std_logic_vector(7 downto 0);
    o_z1 : out std_logic_vector(7 downto 0);
    o_z2 : out std_logic_vector(7 downto 0);
    o_z3 : out std_logic_vector(7 downto 0);
    o_done : out std_logic;
    o_mem_addr : out std_logic_vector(15 downto 0);
    i_mem_data : in std_logic_vector(7 downto 0);
    o_mem_we : out std_logic;
    o_mem_en : out std_logic
);
end project_reti_logiche;
```

## Example Scenarios

The project specification includes six detailed examples demonstrating various input sequences, memory accesses, and output channel routing.

## Development Notes

- Module name must be `project_reti_logiche`
- Only one architecture per entity is allowed
- Violating naming or architecture rules will result in test bench failure

## Academic Information

### Course Details
- **Course:** Reti Logiche
- **Academic Year:** 2022-2023
- **Professors:** 
  - Prof. Fornaciari
  - Prof. Palermo
  - Prof. Salice

### Academic Achievement
- Final Grade: 28/30
- Project Type: Final Exam Project of Reti Logiche

## Requirements
- Development Language: VHDL
- Development Environment: Recommended Xilinx Vivado
- Memory Interface: Provided in test bench (do not synthesize)

## Memory Protocol
Based on Xilinx Vivado Single-Port Block RAM Write-First Mode template

## Contact Information
- **Email:** [michael.alibeaj@mail.polimi.it]
- **Email:** [raffaele.chiaverini@mail.polimi.it]
- **GitHub:** [MikeTech01]
- **GitHub:** [ChiaveriniRaffaele]
