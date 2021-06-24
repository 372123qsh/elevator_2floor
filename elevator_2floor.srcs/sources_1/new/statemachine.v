`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/24 15:21:41
// Design Name: 
// Module Name: statemachine
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


module statemachine(
input clk,
input [3:0] key, // 按键，0在1楼外 1在2楼外 2是电梯内上键 3是电梯内下键
input stop, // 暂停
input repo, // 复位
output reg [1:0] s_op, // 00停在1楼 01停在二楼 10上行 11下行
output reg [3:0] led, // 按键灯，0在1楼外 1在2楼外 2是电梯内上键 3是电梯内下键
output [3:0] row
    );
    assign row[3:0] = 4'b1110; // 键盘最下面一行下拉到地
    integer qi; // 用来计数1~199999999计时4s
    reg flag; // 用于标志延时4s的终点
    assign clk_i = stop & clk; //暂停时时钟被置零，所有功能暂停
    
// LED改变，也就是记录需求的寄存器的改变
    // LED0：按下按键且电梯不停在1楼时亮起
    always @ (posedge clk_i)
    begin
    if (repo == 1)
    begin
        if (s_op == 2'b00)
            led[0] = 0;
        else if (key[0]==0 && s_op != 2'b00)
            led[0] = 1;
    end
    else
        led[0] = 1; // 复位时打开需求，最终回到1楼
    end
    // LED1：按下按键且电梯不停在2楼时亮起
    always @ (posedge clk_i)
    begin
    if (repo == 1)
    begin
        if (s_op == 2'b01)
            led[1] = 0;
        else if (key[1]==0 && s_op != 2'b01)
            led[1] = 1;
    end
    else
        led[1] = 0; // 复位时始终关闭需求
    end
    // LED2：按下按键且电梯不停在2楼时亮起
    always @ (posedge clk_i)
    begin
    if (repo == 1)
    begin
        if (s_op == 2'b01)
            led[2] = 0;
        else if (key[2]==0 && s_op != 2'b01)
            led[2] = 1;
    end
    else
        led[2] = 0; // 复位时始终关闭需求
    end
    // LED3：按下按键且电梯不停在1楼时亮起
    always @ (posedge clk_i)
    begin
    if (repo == 1)
    begin
        if (s_op == 2'b00)
            led[3] = 0;
        else if (key[3]==0 && s_op != 2'b00)
            led[3] = 1;
    end
    else
        led[3] = 0; // 复位时始终关闭需求
    end

// 电梯运行状态改变
    always @ (posedge clk_i)
    begin
        // 当计时未到4s结束且在停止状态，有LED需求时则电梯转为运行状态
        if (flag == 0)
        begin
            if (s_op==2'b00)
            begin
                if ((led[1] == 1)||(led[2] == 1))
                    s_op[1] = 1;
            end
            else if (s_op==2'b01)
            begin
                if ((led[3] == 1)||(led[0] == 1))
                    s_op[1] = 1;
            end
        end
        // 当计时到4s结束时，从运行状态转为停止，楼层反转
        else if (flag == 1)
        begin
            s_op[0] <= ~s_op[0];
            s_op[1] <= ~s_op[1];
        end
    end
             
// 延时4s计时
    always @ (posedge clk_i)
        if (s_op[1] == 1)
        begin
            if (qi==199999999)
            begin
                qi <= 0;
            end
            else
                qi <= qi+1;
        end
        else if (s_op[1] == 0)
            qi <= 0; 

// flag标志，在延时4s最后上升，以使电梯状态改变
    always @ (negedge clk_i)
    begin
        if (qi==199999999)
            flag <= 1;
        else
            flag <= 0;
    end

endmodule