`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/24 15:22:54
// Design Name: 
// Module Name: display
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


module display(
input clk,
input [1:0]state,
input [3:0]led,
output reg [7:0] seg,
output reg [5:0] dig
    );
    
// 分频为1kHz
    reg [24:0] clk_div_cnt=0;
	reg clk_div=0;
	always @ (posedge clk)
	begin
		if (clk_div_cnt==24999)
		begin
			clk_div=~clk_div;
			clk_div_cnt=0;
		end
		else 
		    clk_div_cnt=clk_div_cnt+1;
	end
	
// 2进制计数器
	reg num=0;
	always @ (posedge clk_div)
	begin
		if (num>=1)
			num=0;
		else
			num=num+1;
	end
	
// 译码器
	always @ (num)
	begin
		case(num)
		0:dig=6'b111110;
		1:dig=6'b111101;
		default: dig=0;
		endcase
	end

// 显示译码器
	always@(state)
	if (num == 0)
	begin
		case(state)
		2'b00: seg=8'b00000110;
        2'b01: seg=8'b01011011;
        2'b10: seg=8'b00000110;
        2'b11: seg=8'b01011011;
		default: seg=0;
		endcase
	end
	else if (num == 1)
	begin
	   case(state)
		2'b00: seg=8'b01000000;
        2'b01: seg=8'b01000000;
        2'b10: seg=8'b00000001;
        2'b11: seg=8'b00001000;
		default: seg=0;
		endcase
	end

endmodule