`timescale 1ns / 1ps

module instruction_fetch_unit(
    input clk,
    input reset,

    input [31:0] imm_address,
    input [31:0] imm_address_jump,

    input beq,
    input bneq,
    input bge,
    input blt,
    input jump,

    output reg [31:0] pc,
    output reg [31:0] current_pc
);

    parameter IMEM_START = 32'h00000000;
    parameter IMEM_END   = 32'h00000064;

    wire [31:0] pc_plus4        = pc + 32'd4;
    wire [31:0] pc_next_jump    = pc + imm_address_jump;
    wire [31:0] pc_next_branch  = pc + imm_address;

    wire branch_taken = (beq || bneq || bge || blt);

    // range check helper
    wire valid_jump   = (pc_next_jump   >= IMEM_START) && (pc_next_jump   <= IMEM_END);
    wire valid_branch = (pc_next_branch >= IMEM_START) && (pc_next_branch <= IMEM_END);
    wire valid_seq    = (pc_plus4       >= IMEM_START) && (pc_plus4       <= IMEM_END);

    always @(posedge clk) begin
        if (reset) begin
            pc <= IMEM_START;
        end
        else if (jump && valid_jump) begin
            pc <= pc_next_jump;
        end
        else if (branch_taken && valid_branch) begin
            pc <= pc_next_branch;
        end
        else if (valid_seq) begin
            pc <= pc_plus4;
        end
        else begin
            pc <= pc; // HALT
        end
    end

    // current_pc should represent current instruction address
    always @(posedge clk) begin
        if (reset)
            current_pc <= IMEM_START;
        else
            current_pc <= pc;
    end

    always @(posedge clk) begin
        $display("[IFU] t=%0t pc=%h jump=%b branch_taken=%b",
                 $time, pc, jump, branch_taken);
    end
always @(posedge clk) begin
    if(!reset) begin
        $display("[IFU] t=%0t pc=%h next_pc_seq=%h immB=%h immJ=%h beq=%b bneq=%b bge=%b blt=%b jump=%b",
                $time, pc, pc+4, imm_address, imm_address_jump, beq, bneq, bge, blt, jump);
    end
end

endmodule
