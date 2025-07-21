`timescale 1ns / 1ps
module main(
    input CLK100MHZ,
    input CPU_RESETN,
    input BTNC,
    input BTNU,
    input BTNL,
    input BTNR,
    input BTND,
    input   [11 : 0] SW,
    output  [11 : 0] LED,
    output  [3 : 0] VGA_R,
    output  [3 : 0] VGA_G,
    output  [3 : 0] VGA_B,
    output  VGA_HS,
    output  VGA_VS
);

localparam WIDTH = 640;
localparam HEIGHT = 480;

//logic [11 : 0] videoBuffer[HEIGHT][WIDTH];
logic [11 : 0] drawData;
logic [9 : 0] horizontal;
logic [8 : 0] vertical;

logic clk_25MHz;
logic clk_100MHz;
logic clk_lock;
clk_wiz_0 clkInst(
    .clk_in1(CLK100MHZ),
    .reset(~CPU_RESETN),
    .locked(clk_lock),
    .clk_100MHz(clk_100MHz),
    .clk_25MHz(clk_25MHz)
);

vga_main vga_inst(
    .clk_25MHz(clk_25MHz),
    .reset(~CPU_RESETN),
    .data(drawData),
    .horizontal(horizontal),
    .vertical(vertical),
    .VGA_R(VGA_R),
    .VGA_G(VGA_G),
    .VGA_B(VGA_B),
    .VGA_HS(VGA_HS),
    .VGA_VS(VGA_VS)
);

//logic [11 : 0] videoBuffer[5] = 
//'{
//    {4'h00, 4'h00, 4'h00},
//    {4'h0F, 4'h00, 4'h00},
//    {4'h00, 4'h0F, 4'h00},
//    {4'h00, 4'h00, 4'h0F},
//    {4'h0F, 4'h0F, 4'h0F}
//};

//logic [2 : 0] dataSelect = 0;
logic [11 : 0] videoBuffer = 0;
//always @(posedge clk_100MHz, negedge CPU_RESETN) begin
//    if(~CPU_RESETN)begin
//        videoBuffer <= 0;
//    end else begin
//        videoBuffer <= SW;
//    end
//end
assign drawData = videoBuffer;
assign LED = SW;

logic [3 : 0] size = 15;
logic [9 : 0] xPos = 0;
logic [9 : 0] yPos = 0;

logic [15 : 0] delay = 0;

always @(posedge clk_100MHz, negedge CPU_RESETN) begin
    if(~CPU_RESETN || BTNC)begin
        xPos <= 0;
        yPos <= 0;
    end else begin
        delay <= delay + 1;
        if(delay == 0) begin
            if(BTNU)begin
                yPos <= (0 < yPos) ? yPos - 1 : yPos;
            end else if(BTND)begin
                yPos <= (yPos < HEIGHT - size) ? yPos + 1 : yPos;
            end else if(BTNR)begin
                xPos <= (xPos < WIDTH - size) ? xPos + 1 : xPos;
            end else if(BTNL)begin
                xPos <= (0 < xPos) ? xPos - 1 : xPos;
            end
        end
    end
end

logic objDrawable;
assign objDrawable = (xPos <= horizontal && (xPos + size) > horizontal) && (yPos <= vertical && (yPos + size) > vertical);

always @(posedge clk_100MHz, negedge CPU_RESETN)begin
    if(~CPU_RESETN)begin
        videoBuffer <= 0;
    end else begin
        //videoBuffer <= (0 <= horizontal && horizontal < 128) ? {4'h00, 4'h00, 4'h00} : (128 <= horizontal && horizontal < 256) ? {4'h0F, 4'h00, 4'h00} : (256 <= horizontal && horizontal < 384) ? {4'h00, 4'h0F, 4'h00} : (384 <= horizontal && horizontal < 512) ? {4'h00, 4'h00, 4'h0F} : {4'h0F, 4'h0F, 4'h0F};
        videoBuffer <= objDrawable ? {4'h0F, 4'h0F, 4'h0F} : 12'h00;
    end
end

//initial begin
//    for(int i = 0; i < HEIGHT; i++)begin
//        for(int j = 0; j < WIDTH; j++) begin
//            if(0 <= j && j < 128)begin
//                videoBuffer[i][j] <= {4'h00, 4'h00, 4'h00};
//            end else if(128 <= j && j < 256)begin
//                videoBuffer[i][j] <= {4'h0F, 4'h00, 4'h00};
//            end else if(256 <= j && j < 384) begin
//                videoBuffer[i][j] <= {4'h00, 4'h0F, 4'h00};
//            end else if(384 <= j && j < 512) begin
//                videoBuffer[i][j] <= {4'h00, 4'h00, 4'h0F};
//            end else begin
//                videoBuffer[i][j] <= {4'h0F, 4'h0F, 4'h0F};
//            end
            
//        end
//    end
//end

endmodule