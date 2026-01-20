module control_unit(
    input  reset,
    input  [6:0] funct7,
    input  [2:0] funct3,
    input  [6:0] opcode,

    output reg [5:0] alu_control,

    output reg lb,
    output reg mem_to_reg,
    output reg bneq_control,
    output reg beq_control,
    output reg bgeq_control,
    output reg blt_control,
    output reg jump,
    output reg sw,
    output reg lui_control,

    // ✅ NEW OUTPUTS (needed by datapath)
    output reg reg_write,
    output reg alu_src,
    output reg mem_read,
    output reg mem_write
);

always @(*) begin
    // ✅ DEFAULTS (prevents latches)
    alu_control   = 6'd0;

    lb            = 1'b0;
    sw            = 1'b0;
    mem_to_reg    = 1'b0;

    beq_control   = 1'b0;
    bneq_control  = 1'b0;
    bgeq_control  = 1'b0;
    blt_control   = 1'b0;

    jump          = 1'b0;
    lui_control   = 1'b0;

    // ✅ new control defaults
    reg_write     = 1'b0;
    alu_src       = 1'b0;
    mem_read      = 1'b0;
    mem_write     = 1'b0;

    if (reset) begin
        alu_control = 6'd0;
    end

    // -------------------- R-TYPE --------------------
    else if (opcode == 7'b0110011) begin
        reg_write = 1'b1;
        alu_src   = 1'b0;

        case (funct3)
            3'b000: begin
                if (funct7 == 7'b0000000) alu_control = 6'b000001; // ADD
                else if (funct7 == 7'b0100000) alu_control = 6'b000010; // SUB
            end
            3'b001: alu_control = 6'b000011; // SLL
            3'b010: alu_control = 6'b000100; // SLT
            3'b011: alu_control = 6'b000101; // SLTU
            3'b100: alu_control = 6'b000110; // XOR
            3'b101: begin
                if (funct7 == 7'b0000000) alu_control = 6'b000111; // SRL
                else if (funct7 == 7'b0100000) alu_control = 6'b001000; // SRA
            end
            3'b110: alu_control = 6'b001001; // OR
            3'b111: alu_control = 6'b001010; // AND
        endcase
    end

    // -------------------- I-TYPE (OP-IMM) --------------------
    else if (opcode == 7'b0010011) begin
        reg_write = 1'b1;
        alu_src   = 1'b1;

        case (funct3)
            3'b000: alu_control = 6'b001011; // ADDI
            3'b001: alu_control = 6'b001100; // SLLI
            3'b010: alu_control = 6'b001101; // SLTI
            3'b011: alu_control = 6'b001110; // SLTIU
            3'b100: alu_control = 6'b001111; // XORI
            3'b101: begin
                if (funct7 == 7'b0000000) alu_control = 6'b010000; // SRLI
                else if (funct7 == 7'b0100000) alu_control = 6'b010011; // SRAI
            end
            3'b110: alu_control = 6'b010001; // ORI
            3'b111: alu_control = 6'b010010; // ANDI
        endcase
    end

    // -------------------- LOAD --------------------
    else if (opcode == 7'b0000011) begin
        reg_write = 1'b1;
        alu_src   = 1'b1;

        mem_read  = 1'b1;
        mem_to_reg= 1'b1;
        lb        = 1'b1;   // your load enable name

        // ALU will do address calc (rs1 + imm)
        alu_control = 6'b001011; // use ADD for address

        // (Optional: funct3 can be used later for LB/LH/LW)
    end

    // -------------------- STORE --------------------
    else if (opcode == 7'b0100011) begin
        reg_write = 1'b0;
        alu_src   = 1'b1;

        mem_write = 1'b1;
        sw        = 1'b1;

        // ALU will do address calc (rs1 + imm)
        alu_control = 6'b001011; // use ADD for address
    end

    // -------------------- BRANCH --------------------
    else if (opcode == 7'b1100011) begin
        reg_write = 1'b0;
        alu_src   = 1'b0;

        case (funct3)
            3'b000: begin // BEQ
                alu_control = 6'b011011;
                beq_control = 1'b1;
            end
            3'b001: begin // BNE
                alu_control = 6'b011100;
                bneq_control = 1'b1;
            end
            3'b100: begin // BLT
                alu_control = 6'b100000;
                blt_control = 1'b1;
            end
            3'b101: begin // BGE
                alu_control = 6'b011111;
                bgeq_control = 1'b1;
            end
        endcase
    end

    // -------------------- LUI --------------------
    else if (opcode == 7'b0110111) begin
        reg_write   = 1'b1;
        lui_control = 1'b1;
        alu_control = 6'b100001;
    end

    // -------------------- JAL --------------------
    else if (opcode == 7'b1101111) begin
        reg_write = 1'b1;   // JAL writes to rd (PC+4)
        jump      = 1'b1;
        alu_control = 6'b100010;
    end
end
always @(*) begin
    $display("[CU] t=%0t opcode=%b funct3=%b funct7=%b alu_ctrl=%b regW=%b alu_src=%b memR=%b memW=%b mem2reg=%b jump=%b beqC=%b bneqC=%b bgeC=%b bltC=%b lui=%b",
        $time, opcode, funct3, funct7, alu_control,
        reg_write, alu_src, mem_read, mem_write, mem_to_reg,
        jump, beq_control, bneq_control, bgeq_control, blt_control, lui_control);
end

endmodule
