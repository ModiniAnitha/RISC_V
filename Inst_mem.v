`timescale 1ns / 1ps


module instruction_memory(
    input  clk,
    input  reset,
    input  [31:0] pc,
    output [31:0] instruction_code
);

    reg [7:0] memory [0:108];

    // ✅ Instruction fetch (little-endian)
    assign instruction_code =
        (pc <= 32'd105) ? {memory[pc+3], memory[pc+2], memory[pc+1], memory[pc]}
                        : 32'h00000013;  // NOP (addi x0,x0,0)

    // ✅ Load IMEM contents from file
    always @(posedge clk) begin
        if (reset) begin
            $readmemh("C:/RISC_V/kyber_zetas.mem", memory);
        end
    end
always @(posedge clk) begin
    if(!reset) begin
        $display("[IMEM] t=%0t pc=%h instr=%h", $time, pc, instruction_code);
    end
end
always @(posedge clk) begin
    if (reset) begin
        $readmemh("C:/RISC_V/kyber_zetas.mem", memory);
        $display("[IMEM] Loaded imem.mem at t=%0t", $time);
    end
end

endmodule

