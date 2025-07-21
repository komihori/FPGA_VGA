`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/19 01:25:53
// Design Name: 
// Module Name: vga_main_tb
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


module vga_main_tb(    );
localparam WIDTH = 640;
localparam HEIGHT = 480;

logic clk = 0;
logic reset = 0;
logic  [3 : 0] VGA_R = 0;
logic  [3 : 0] VGA_G = 0;
logic  [3 : 0] VGA_B = 0;
logic  VGA_HS = 0;
logic  VGA_VS = 0;
logic [9 : 0] horizontal;
logic [8 : 0] vertical;
logic [11 : 0] drawData;

logic [11 : 0] videoBuffer[HEIGHT][WIDTH];

//{4'h00, 4'h00, 4'h00}
//{4'h0F, 4'h00, 4'h00}
//{4'h00, 4'h0F, 4'h00}
//{4'h00, 4'h00, 4'h0F}
//{4'h0F, 4'h0F, 4'h0F}


always #5 clk <= ~clk;

vga_main vga_inst(
    .CLK100MHZ(clk),
    .reset(reset),
    .data(drawData),
    .horizontal(horizontal),
    .vertical(vertical),
    .VGA_R(VGA_R),
    .VGA_G(VGA_G),
    .VGA_B(VGA_B),
    .VGA_HS(VGA_HS),
    .VGA_VS(VGA_VS)
);

assign drawData = videoBuffer[vertical][horizontal];

initial begin
    for(int i = 0; i < HEIGHT; i++)begin
        for(int j = 0; j < WIDTH; j++) begin
            if(0 <= j && j < 128)begin
                videoBuffer[i][j] <= {4'h00, 4'h00, 4'h00};
            end else if(128 <= j && j < 256)begin
                videoBuffer[i][j] <= {4'h0F, 4'h00, 4'h00};
            end else if(256 <= j && j < 384) begin
                videoBuffer[i][j] <= {4'h00, 4'h0F, 4'h00};
            end else if(384 <= j && j < 512) begin
                videoBuffer[i][j] <= {4'h00, 4'h00, 4'h0F};
            end else begin
                videoBuffer[i][j] <= {4'h0F, 4'h0F, 4'h0F};
            end
            
        end
    end
    #(40 * 420000 * 2) $finish;
end

endmodule
