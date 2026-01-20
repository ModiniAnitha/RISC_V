The Reduced Instruction Set Computer [RISC]
processor is a computer arithmetic-logical unit that
has a small set of instructions that optimizes the entire
logic in most frequently used instructions which can
be quickly accessible for faster execution. Compared
to CISC and RISC processors software must handle a
greater number of operations per cycle. The RISC
processors have a trump card in entreaty that will be
helpful to perform faster instruction execution. The
process of designing, testing, and manufacturing
them is also relatively inexpensive. The instruction
register became very complex to design and the
control unit occupies most of the chip area the
instructions that access memory results in decreasing
the speed execution. Thus, the RISC processor is
developed, and a small set of instructions results in
simplifies the design and improves the overall
performance of the processor
<img width="335" height="69" alt="image" src="https://github.com/user-attachments/assets/fa8c7a6b-c7b6-4225-a4ab-4726262c9de3" />
This project implements a 32-bit RISC-V single-cycle processor using Verilog HDL. The processor follows the basic RISC-V instruction execution flow:

✅ Instruction Fetch (IF)
✅ Instruction Decode (ID)
✅ Execute (EX)
✅ Memory Access (MEM)
✅ Write Back (WB)

The design is simulated and verified in Xilinx Vivado (XSim) using a .mem file for instruction memory initialization. The processor successfully executes arithmetic, logical, memory, branch, and jump instructions.

✨ Features

32-bit RISC-V datapath

Single-cycle execution (one instruction completes in one clock cycle)

Modular architecture for easy understanding and debugging

Supports basic RISC-V instruction categories:

R-Type (ADD, SUB, AND, OR, XOR, shifts, SLT)

I-Type (ADDI, ANDI, ORI, XORI, shifts)

Load (LB / LW based on implementation)

Store (SW)

Branch (BEQ, BNE, BGE, BLT)

Jump (JAL)

Upper Immediate (LUI)

🧩 Block Level Description

The processor is designed using the following blocks:

1. Instruction Fetch Unit (IFU)

Maintains the Program Counter (PC)

Generates the next PC value:

PC + 4 for sequential execution

PC + branch_offset when branch is taken

PC + jump_offset for jump instructions

2. Instruction Memory (IMEM)

Stores instructions in .mem format

Outputs a 32-bit instruction based on the PC value

3. Control Unit (CU)

Decodes opcode, funct3, and funct7

Generates control signals such as:

reg_write

alu_src

mem_read

mem_write

mem_to_reg

branch and jump control signals

4. Immediate Generator (IMM GEN)

Generates signed immediates for:

I-Type

S-Type

B-Type

J-Type

U-Type (LUI)

5. Register File (RF)

Contains 32 general-purpose registers x0–x31

Two read ports + one write port

x0 is always zero (as per RISC-V spec)

6. ALU

Performs arithmetic and logical operations

Supported operations are selected using alu_control

7. Data Memory (DMEM)

Performs memory read/write operations

Used for Load and Store instructions

8. Datapath Integration

Connects all components to execute full instructions

Branch condition outputs:

beq, bneq, bge, blt

These are sent to IFU for PC update
