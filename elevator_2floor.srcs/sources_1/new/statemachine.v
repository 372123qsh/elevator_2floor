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
input [3:0] key, // ������0��1¥�� 1��2¥�� 2�ǵ������ϼ� 3�ǵ������¼�
input stop, // ��ͣ
input repo, // ��λ
output reg [1:0] s_op, // 00ͣ��1¥ 01ͣ�ڶ�¥ 10���� 11����
output reg [3:0] led, // �����ƣ�0��1¥�� 1��2¥�� 2�ǵ������ϼ� 3�ǵ������¼�
output [3:0] row
    );
    assign row[3:0] = 4'b1110; // ����������һ����������
    integer qi; // ��������1~199999999��ʱ4s
    reg flag; // ���ڱ�־��ʱ4s���յ�
    assign clk_i = stop & clk; //��ͣʱʱ�ӱ����㣬���й�����ͣ
    
// LED�ı䣬Ҳ���Ǽ�¼����ļĴ����ĸı�
    // LED0�����°����ҵ��ݲ�ͣ��1¥ʱ����
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
        led[0] = 1; // ��λʱ���������ջص�1¥
    end
    // LED1�����°����ҵ��ݲ�ͣ��2¥ʱ����
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
        led[1] = 0; // ��λʱʼ�չر�����
    end
    // LED2�����°����ҵ��ݲ�ͣ��2¥ʱ����
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
        led[2] = 0; // ��λʱʼ�չر�����
    end
    // LED3�����°����ҵ��ݲ�ͣ��1¥ʱ����
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
        led[3] = 0; // ��λʱʼ�չر�����
    end

// ��������״̬�ı�
    always @ (posedge clk_i)
    begin
        // ����ʱδ��4s��������ֹͣ״̬����LED����ʱ�����תΪ����״̬
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
        // ����ʱ��4s����ʱ��������״̬תΪֹͣ��¥�㷴ת
        else if (flag == 1)
        begin
            s_op[0] <= ~s_op[0];
            s_op[1] <= ~s_op[1];
        end
    end
             
// ��ʱ4s��ʱ
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

// flag��־������ʱ4s�����������ʹ����״̬�ı�
    always @ (negedge clk_i)
    begin
        if (qi==199999999)
            flag <= 1;
        else
            flag <= 0;
    end

endmodule