`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: TADAKAMALLA GOURAV
// 
// Create Date: 07/15/2024 10:23:37 AM
// Design Name: 
// Module Name: data_path
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
//////////////////////////////////////////////////////////////////////////////////
module data_path(
    input  clk,
    input  rst,

    input  [4:0] read_reg_num1,      // rs1
    input  [4:0] read_reg_num2,      // rs2
    input  [4:0] write_reg_num1,     // rd

    input  [5:0] alu_control,

    input  jump,
    input  beq_control,
    input  bne_control,
    input  bgeq_control,
    input  blt_control,

    input  alu_src,          // 1 => use imm, 0 => use rs2
    input  reg_write,        // enable writing into register file
    input  mem_to_reg,       // 1 => writeback from memory, 0 => from ALU
    input  mem_read,         // load enable
    input  mem_write,        // store enable

    input  [31:0] imm_val,
    input  [31:0] imm_val_lui,
    input  lui_control,

    output beq,
    output bneq,
    output bge,
    output blt
);

    wire [31:0] read_data1;
    wire [31:0] read_data2;

    wire [31:0] alu_in2;
    wire [31:0] alu_result;

    wire [31:0] mem_data;
    wire [31:0] wb_data;

    wire [31:0] store_data;

    // ALU second input mux
    assign alu_in2 = (alu_src) ? imm_val : read_data2;

    // Writeback mux
    assign wb_data = (lui_control) ? imm_val_lui :
                     (mem_to_reg)  ? mem_data    :
                                     alu_result;

    // Register File
    register_file rfu (
        .clk(clk),
        .rst(rst),
        .read_reg_num1(read_reg_num1),
        .read_reg_num2(read_reg_num2),
        .write_reg_num1(write_reg_num1),
        .write_data(wb_data),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .store_data(store_data)
    );

    // ALU
    alu alu_unit (
        .src1(read_data1),
        .src2(alu_in2),
        .alu_control(alu_control),
        .result(alu_result)
    );

    // Data Memory (byte addressed, supports LW/SW)
    data_memory dmu (
        .clk(clk),
        .rst(rst),
        .addr(alu_result),       // ✅ address from ALU (rs1 + imm)
        .wr_data(store_data),    // ✅ store rs2
        .mem_read(mem_read),
        .mem_write(mem_write),
        .rd_data(mem_data)
    );

    // Branch condition outputs (taken/not taken)
    assign beq  = (beq_control  && (alu_result == 32'd1));
    assign bneq = (bne_control  && (alu_result == 32'd1));
    assign bge  = (bgeq_control && (alu_result == 32'd1));
    assign blt  = (blt_control  && (alu_result == 32'd1));
always @(posedge clk) begin
    if(!rst) begin
        $display("[DPU] t=%0t rs1=%0d rs2=%0d rd=%0d imm=%h alu_ctrl=%b alu_src=%b alu_res=%h memR=%b memW=%b mem2reg=%b wb=%h",
            $time, read_reg_num1, read_reg_num2, write_reg_num1,
            imm_val, alu_control, alu_src, alu_result,
            mem_read, mem_write, mem_to_reg, wb_data);
    end
end

endmodule
