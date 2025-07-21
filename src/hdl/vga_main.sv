`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/19 00:18:27
// Design Name: 
// Module Name: vga_main
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


module vga_main#(
    parameter WIDTH = 640,
    parameter HEIGHT = 480
)(
    input   clk_25MHz,
    input   reset,
    input   [11 : 0] data,
    output  [9 : 0] horizontal,
    output  [8 : 0] vertical,
    output  [3 : 0] VGA_R,
    output  [3 : 0] VGA_G,
    output  [3 : 0] VGA_B,
    output  VGA_HS,
    output  VGA_VS
    );
    
    typedef enum {
        stFrontPorch,
        stPulse,
        stBackPorch,
        stDisplay
    }SyncState_t;
    
    (* keep = "true" *)SyncState_t hSyncState = stFrontPorch;
    (* keep = "true" *)SyncState_t vSyncState = stFrontPorch;
    
    (* keep = "true" *)logic [9 : 0] hSyncCount = 0;
    (* keep = "true" *)logic [9 : 0] vSyncCount = 0;
    
    logic hSync;
    logic vSync;
    
    logic [9 : 0] currentWidth = 0;
    logic [8 : 0] currentHeight = 0;

    assign VGA_HS = hSync;
    assign VGA_VS = vSync;
    
    assign hSync = ~(hSyncState == stPulse);
    assign vSync = ~(vSyncState == stPulse);
    
    assign horizontal = currentWidth;
    assign vertical = currentHeight;
    
    assign {VGA_R, VGA_G, VGA_B} = (hSyncState == stDisplay && vSyncState == stDisplay) ? data : 12'h0;
    
    always @(posedge clk_25MHz, posedge reset)begin
        if(reset) begin
            hSyncState <= stFrontPorch;
            hSyncCount <= 0;
            currentWidth <= 0;
            currentHeight <= 0;
        end else begin
            hSyncCount <= hSyncCount + 1;
            case(hSyncState) 
                stFrontPorch : begin
                    if(hSyncCount == 15) begin
                        hSyncState <= stPulse;
                        currentHeight <= (vSyncState == stDisplay) ? (currentHeight + 1) : 0;
                    end
                end
                
                stPulse : begin
                    if(hSyncCount == 111)begin
                        hSyncState <= stBackPorch;
                    end
                end
                
                stBackPorch : begin
                    if(hSyncCount == 159)begin
                        hSyncState <= stDisplay;
                    end
                end
                
                stDisplay : begin
                    currentWidth <= currentWidth + 1;
                    if(hSyncCount == 799)begin
                        hSyncState <= stFrontPorch;
                        hSyncCount <= 0;
                        currentWidth <= 0;
                    end
                end
                
                default : begin
                    hSyncState <= stFrontPorch;
                    hSyncCount <= 0;
                    currentWidth <= 0;
                    currentHeight <= 0;
                end
            endcase
        end
    end
    
    always @(negedge hSync, posedge reset)begin
        if(reset)begin
            vSyncState <= stFrontPorch;
            vSyncCount <= 0;
        end else begin
            vSyncCount <= vSyncCount + 1;
            case(vSyncState) 
                stFrontPorch : begin
                    if(vSyncCount == 9)begin
                        vSyncState <= stPulse;
                    end
                end
                
                stPulse : begin
                    if(vSyncCount == 11) begin
                        vSyncState <= stBackPorch;
                    end
                end
                
                stBackPorch : begin
                    if(vSyncCount == 44)begin
                        vSyncState <= stDisplay;
                    end
                end
                
                stDisplay : begin
                    if(vSyncCount == 524)begin
                        vSyncState <= stFrontPorch;
                        vSyncCount <= 0;
                    end
                end
                
                default : begin
                    vSyncState <= stFrontPorch;
                    vSyncCount <= 0;
                end
            endcase
        end
    end
    
endmodule
