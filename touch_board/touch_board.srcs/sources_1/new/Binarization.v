module Binarization(
	input clk,
	input [11:0] rgb_data,//输入rgb数据
	output reg[11:0] binary_data//二�?�化结果 
);
	reg [7:0]red,green,blue,avg;
	always@(*)
	begin
		red={rgb_data[11:8],4'b0000};
		green={rgb_data[7:4],4'b0000};
		blue={rgb_data[3:0],4'b0000};
		avg=(red+green+blue)/3;
		if(avg>=100)
		begin
			red=255;
			green=255;
			blue=255;
		end
		else
		begin
			red=0;
			green=0;
			blue=0;
		end
		binary_data[11:8]=red[7:4];
		binary_data[7:4]=green[7:4];
		binary_data[3:0]=blue[7:4];
	end
endmodule
