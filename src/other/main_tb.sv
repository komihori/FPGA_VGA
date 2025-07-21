`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/19 16:05:48
// Design Name: 
// Module Name: main_tb
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


module main_tb();
logic CLK100MHZ = 0;
logic CPU_RESETN = 0;
logic   [3 : 0] SW = 0;
logic  [3 : 0] VGA_R;
logic  [3 : 0] VGA_G;
logic  [3 : 0] VGA_B;
logic  VGA_HS;
logic  VGA_VS;

main mainInst(
    .CLK100MHZ(CLK100MHZ),
    .CPU_RESETN(CPU_RESETN),
    .SW(SW),
    .VGA_R(VGA_R),
    .VGA_G(VGA_G),
    .VGA_B(VGA_B),
    .VGA_HS(VGA_HS),
    .VGA_VS(VGA_VS)
);

always #5 CLK100MHZ <= ~CLK100MHZ;

initial begin
    #10 CPU_RESETN = 0;
    #10 CPU_RESETN = 1;
    #0  SW = 0;
    #(40 * 384000 * 20) $finish;
end

endmodule
