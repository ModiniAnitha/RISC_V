`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2024 04:01:53 PM
// Design Name: 
// Module Name: top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 

`timescale 1ns / 1ps

module top_tb;

    reg clk;
    reg reset;

    // ✅ Wires for debug outputs
    wire [31:0] pc_out;
    wire [31:0] instr_out;
    wire [31:0] imm_out;

    wire [5:0] alu_ctrl_out;

    wire jump_out;
    wire beq_out;
    wire bneq_out;
    wire bge_out;
    wire blt_out;

    wire reg_write_out;
    wire alu_src_out;
    wire mem_read_out;
    wire mem_write_out;
    wire mem_to_reg_out;

    // DUT
    top_riscv dut (
        .clk(clk),
        .reset(reset),

        .pc_out(pc_out),
        .instr_out(instr_out),
        .imm_out(imm_out),

        .alu_ctrl_out(alu_ctrl_out),

        .jump_out(jump_out),
        .beq_out(beq_out),
        .bneq_out(bneq_out),
        .bge_out(bge_out),
        .blt_out(blt_out),

        .reg_write_out(reg_write_out),
        .alu_src_out(alu_src_out),
        .mem_read_out(mem_read_out),
        .mem_write_out(mem_write_out),
        .mem_to_reg_out(mem_to_reg_out)
    );

    // Clock: 20ns period
    initial clk = 1'b0;
    always #10 clk = ~clk;

    // Reset
    initial begin
        reset = 1'b1;
        #50;
        reset = 1'b0;
    end

    // ✅ Stop simulation after long time
    initial begin
        #600000;
        $display("Simulation finished at t=%0t", $time);
        $finish;
    end

    // Monitor (optional)
    initial begin
      $monitor("t=%0t reset=%b pc=%h instr=%h jump=%b beq=%b bneq=%b bge=%b blt=%b imm=%h alu_ctrl=%b",
               $time, reset,
               pc_out,
               instr_out,
               jump_out,
               beq_out,
               bneq_out,
               bge_out,
               blt_out,
               imm_out,
               alu_ctrl_out);
    end

endmodule
