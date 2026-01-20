`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 02:20:44 PM
// Design Name: 
// Module Name: alu
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

module alu(
    input  [31:0] src1,
    input  [31:0] src2,
    input  [5:0]  alu_control,
    output reg [31:0] result
);

always @(*) begin
    result = 32'd0;

    case(alu_control)

        // R-type basic
        6'b000001: result = src1 + src2;                      // ADD
        6'b000010: result = src1 - src2;                      // SUB
        6'b000011: result = src1 << src2[4:0];                // SLL
        6'b000100: result = ($signed(src1) < $signed(src2)) ? 32'd1 : 32'd0;  // SLT
        6'b000101: result = (src1 < src2) ? 32'd1 : 32'd0;    // SLTU
        6'b000110: result = src1 ^ src2;                      // XOR
        6'b000111: result = src1 >> src2[4:0];                // SRL
        6'b001000: result = $signed(src1) >>> src2[4:0];      // SRA
        6'b001001: result = src1 | src2;                      // OR
        6'b001010: result = src1 & src2;                      // AND

        // I-type arithmetic (you can reuse same operations)
        6'b001011: result = src1 + src2;                      // ADDI (src2 already imm)
        6'b001100: result = src1 << src2[4:0];                // SLLI
        6'b001101: result = ($signed(src1) < $signed(src2)) ? 32'd1 : 32'd0; // SLTI
        6'b001110: result = (src1 < src2) ? 32'd1 : 32'd0;    // SLTIU
        6'b001111: result = src1 ^ src2;                      // XORI
        6'b010000: result = src1 >> src2[4:0];                // SRLI
        6'b010001: result = src1 | src2;                      // ORI
        6'b010010: result = src1 & src2;                      // ANDI
        6'b010011: result = $signed(src1) >>> src2[4:0];      // SRAI (optional code)

        // Branch compare results (return 1 if true)
        6'b011011: result = (src1 == src2) ? 32'd1 : 32'd0;   // BEQ
        6'b011100: result = (src1 != src2) ? 32'd1 : 32'd0;   // BNE
        6'b011111: result = ($signed(src1) >= $signed(src2)) ? 32'd1 : 32'd0; // BGE
        6'b100000: result = ($signed(src1) <  $signed(src2)) ? 32'd1 : 32'd0; // BLT

        default: result = 32'd0;
    endcase
end

endmodule
