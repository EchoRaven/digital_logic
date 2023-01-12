`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/03 22:21:18
// Design Name: 
// Module Name: test_tb
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


module test_tb();
reg clk_vga;//输入vga的时钟，频率为25.175MHz
reg rst;//复位信号，高电平有效
reg clr;
reg [11:0] color_data_in;//从RAM中读取的像素信息
wire[18:0] ram_addr;//应该读取的RAM的图片地址，由vga_control给出
wire x_valid;
wire y_valid;
wire reg[3:0] red;
wire[3:0] blue;
wire[3:0] green;
integer i,j;
vga_display vga(.clk_vga(clk_vga),.rst(rst),.clr(clr),.color_data_in(color_data_in),.ram_addr(ram_addr),.x_valid(x_valid),.y_valid(y_valid),.red(red),.blue(blue),.green(green));
initial
begin
    clk_vga=0;
    clr=0;
    rst=0;
    for(i=0;i<=7990;i=i+1)
    begin
        for(j=0;j<=5240;j=j+1)
        begin
            #1
            clk_vga=1-clk_vga;
            if((j%799)<=3*(i%524)+300+40 && (j%799)>=3*(i%524)+300-40)
            begin
                color_data_in=12'b000000000000;
            end
            else
                color_data_in=12'b111111111111;
        end
    end
end
endmodule
