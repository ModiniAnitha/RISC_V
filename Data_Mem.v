`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2024 10:19:04 AM
// Design Name: 
// Module Name: data_memory
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

module data_memory(
    input  clk,
    input  rst,

    input  [31:0] addr,        // byte address
    input  [31:0] wr_data,

    input  mem_read,
    input  mem_write,

    output [31:0] rd_data
);

    reg [7:0] data_mem [0:255];
    integer i;

    wire [7:0] a = addr[7:0]; // small memory for now

    always @(posedge clk) begin
        if (rst) begin
            for (i=0; i<256; i=i+1)
                data_mem[i] <= 8'd0;
        end
        else if (mem_write) begin
            // ✅ SW store 32-bit little endian
            data_mem[a + 0] <= wr_data[7:0];
            data_mem[a + 1] <= wr_data[15:8];
            data_mem[a + 2] <= wr_data[23:16];
            data_mem[a + 3] <= wr_data[31:24];
        end
    end

    // ✅ LW load 32-bit little endian
    assign rd_data = (mem_read) ? {data_mem[a+3], data_mem[a+2], data_mem[a+1], data_mem[a+0]}
                                : 32'd0;
                                
                                always @(posedge clk) begin
    if(!rst) begin
        if(mem_write)
            $display("[DMEM] t=%0t WRITE addr=%h data=%h", $time, addr, wr_data);
        if(mem_read)
            $display("[DMEM] t=%0t READ  addr=%h data=%h", $time, addr, rd_data);
    end
end


endmodule
