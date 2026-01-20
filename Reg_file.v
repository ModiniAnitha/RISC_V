`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2024 03:55:05 PM
// Design Name: 
// Module Name: register_file
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
module register_file(
    input  clk,
    input  rst,

    input  [4:0] read_reg_num1,
    input  [4:0] read_reg_num2,
    input  [4:0] write_reg_num1,

    input  [31:0] write_data,
    input  reg_write,

    output [31:0] read_data1,
    output [31:0] read_data2,
    output [31:0] store_data
);

    reg [31:0] reg_mem [0:31];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i=0; i<32; i=i+1)
                reg_mem[i] <= 32'd0;
        end
        else begin
            // ✅ writeback
            if (reg_write && (write_reg_num1 != 5'd0))
                reg_mem[write_reg_num1] <= write_data;

            // ✅ x0 always zero
            reg_mem[0] <= 32'd0;
        end
    end

    assign read_data1 = reg_mem[read_reg_num1];
    assign read_data2 = reg_mem[read_reg_num2];

    // ✅ store data must be rs2 value
    assign store_data = read_data2;
always @(posedge clk) begin
    if(!rst) begin
        $display("[RF] t=%0t rs1=x%0d=%h rs2=x%0d=%h rd=x%0d reg_write=%b wb=%h",
            $time,
            read_reg_num1, read_data1,
            read_reg_num2, read_data2,
            write_reg_num1, reg_write, write_data);
    end
end

endmodule
