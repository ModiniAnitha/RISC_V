


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
    parameter IMEM_END   = 32'h00000064; // last valid instruction

    wire [31:0] pc_next_jump   = pc + imm_address_jump;
    wire [31:0] pc_next_branch = pc + imm_address;

    always @(posedge clk) begin
        if (reset) begin
            pc <= IMEM_START;
        end
        // 🚫 BLOCK INVALID JUMP
        else if (jump && (pc_next_jump <= IMEM_END)) begin
            pc <= pc_next_jump;
        end
        // 🚫 BLOCK INVALID BRANCH
        else if ((beq || bneq || bge || blt) && (pc_next_branch <= IMEM_END)) begin
            pc <= pc_next_branch;
        end
        // 🚫 HALT if PC exceeds instruction memory
        else if (pc + 4 <= IMEM_END) begin
            pc <= pc + 4;
        end
        else begin
            pc <= pc;   // HALT
        end
    end

    always @(posedge clk) begin
        if (reset)
            current_pc <= 32'd0;
        else
            current_pc <= pc + 32'd4;
    end

    always @(posedge clk) begin
        $display("[IFU] t=%0t pc=%h | beq=%b bneq=%b bge=%b blt=%b jump=%b",
                 $time, pc, beq, bneq, bge, blt, jump);
    end

endmodule
