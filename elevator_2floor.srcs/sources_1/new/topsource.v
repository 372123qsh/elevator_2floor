`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/24 15:20:27
// Design Name: 
// Module Name: topsource
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


module topsource(
input clk,
input [3:0] key,
input runstop,
input repo,
output [3:0] row,
output [7:0] seg,
output [5:0] dig,
output [3:0] displed
    );
    
    wire [1:0] state;
        
    statemachine uu1(
    .clk(clk),
    .key(key),
    .stop(runstop),
    .repo(repo),
    .s_op(state),
    .led(displed),
    .row(row)
    );
    
    display uu2(
    .clk(clk),
    .state(state),
    .led(displed),
    .seg(seg),
    .dig(dig)
    );
    
endmodule