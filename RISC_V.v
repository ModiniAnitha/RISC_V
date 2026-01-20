`timescale 1ns / 1ps

module top_riscv(
    input  clk,
    input  reset,

    // ✅ Debug outputs for waveform
    output [31:0] pc_out,
    output [31:0] instr_out,
    output [31:0] imm_out,

    output [5:0]  alu_ctrl_out,

    output jump_out,
    output beq_out,
    output bneq_out,
    output bge_out,
    output blt_out,

    output reg_write_out,
    output alu_src_out,
    output mem_read_out,
    output mem_write_out,
    output mem_to_reg_out
);

    // -------------------- Wires --------------------
    wire [31:0] pc;
    wire [31:0] current_pc;
    wire [31:0] instruction_out;

    wire [5:0] alu_control;

    wire lb;
    wire sw;
    wire mem_to_reg;
    wire jump;
    wire beq_control;
    wire bneq_control;
    wire bgeq_control;
    wire blt_control;
    wire lui_control;

    wire reg_write;
    wire alu_src;
    wire mem_read;
    wire mem_write;

    wire [31:0] imm_val;
    wire [31:0] imm_val_lui;

    wire beq, bneq, bge, blt;

    // -------------------- IFU --------------------
    instruction_fetch_unit ifu(
        .clk(clk),
        .reset(reset),

        .imm_address(imm_val),
        .imm_address_jump(imm_val),

        .beq(beq),
        .bneq(bneq),
        .bge(bge),
        .blt(blt),
        .jump(jump),

        .pc(pc),
        .current_pc(current_pc)
    );

    // -------------------- Instruction Memory --------------------
    instruction_memory imu(
        .clk(clk),
        .pc(pc),
        .reset(reset),
        .instruction_code(instruction_out)
    );

    // -------------------- Immediate Generator --------------------
    imm_gen igu(
        .instr_memory(instruction_out),
        .imm_val_r(imm_val),
        .imm_val_lui(imm_val_lui)
    );

    // -------------------- Control Unit --------------------
    control_unit cu(
        .reset(reset),
        .funct7(instruction_out[31:25]),
        .funct3(instruction_out[14:12]),
        .opcode(instruction_out[6:0]),

        .alu_control(alu_control),
        .lb(lb),
        .mem_to_reg(mem_to_reg),
        .bneq_control(bneq_control),
        .beq_control(beq_control),
        .bgeq_control(bgeq_control),
        .blt_control(blt_control),
        .jump(jump),
        .sw(sw),
        .lui_control(lui_control),

        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write)
    );

    // -------------------- Data Path --------------------
    data_path dpu(
        .clk(clk),
        .rst(reset),

        .read_reg_num1(instruction_out[19:15]),
        .read_reg_num2(instruction_out[24:20]),
        .write_reg_num1(instruction_out[11:7]),

        .alu_control(alu_control),

        .jump(jump),
        .beq_control(beq_control),
        .bne_control(bneq_control),
        .bgeq_control(bgeq_control),
        .blt_control(blt_control),

        .alu_src(alu_src),
        .reg_write(reg_write),
        .mem_to_reg(mem_to_reg),
        .mem_read(mem_read),
        .mem_write(mem_write),

        .imm_val(imm_val),
        .imm_val_lui(imm_val_lui),
        .lui_control(lui_control),

        .beq(beq),
        .bneq(bneq),
        .bge(bge),
        .blt(blt)
    );

    // ✅ Assign debug outputs
    assign pc_out         = pc;
    assign instr_out      = instruction_out;
    assign imm_out        = imm_val;

    assign alu_ctrl_out   = alu_control;

    assign jump_out       = jump;
    assign beq_out        = beq;
    assign bneq_out       = bneq;
    assign bge_out        = bge;
    assign blt_out        = blt;

    assign reg_write_out  = reg_write;
    assign alu_src_out    = alu_src;
    assign mem_read_out   = mem_read;
    assign mem_write_out  = mem_write;
    assign mem_to_reg_out = mem_to_reg;

endmodule
