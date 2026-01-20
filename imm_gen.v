`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 04:24:53 PM
// Design Name: 
// Module Name: imm_gen
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

module imm_gen(
    input  [31:0] instr_memory,
    output reg [31:0] imm_val_r,     // main imm
    output reg [31:0] imm_val_lui    // lui imm
);

    wire [6:0] opcode = instr_memory[6:0];

    always @(*) begin
        imm_val_r    = 32'd0;
        imm_val_lui  = 32'd0;

        case(opcode)

            // I-type (OP-IMM, LOAD, JALR)
            7'b0010011,
            7'b0000011,
            7'b1100111: begin
                imm_val_r = {{20{instr_memory[31]}}, instr_memory[31:20]};
            end

            // S-type (STORE)
            7'b0100011: begin
                imm_val_r = {{20{instr_memory[31]}}, instr_memory[31:25], instr_memory[11:7]};
            end

            // B-type (BRANCH)
            7'b1100011: begin
                imm_val_r = {{19{instr_memory[31]}},
                             instr_memory[31],
                             instr_memory[7],
                             instr_memory[30:25],
                             instr_memory[11:8],
                             1'b0};
            end

            // U-type (LUI/AUIPC)
            7'b0110111,
            7'b0010111: begin
                imm_val_lui = {instr_memory[31:12], 12'd0};
                imm_val_r   = imm_val_lui;
            end

            // J-type (JAL)
            7'b1101111: begin
                imm_val_r = {{11{instr_memory[31]}},
                             instr_memory[31],
                             instr_memory[19:12],
                             instr_memory[20],
                             instr_memory[30:21],
                             1'b0};
            end

            default: begin
                imm_val_r = 32'd0;
            end
        endcase
    end
always @(posedge opcode[0]) begin
    $display("[IMM] instr=%h opcode=%b imm=%h", instr_memory, opcode, imm_val_r);
end

endmodule
