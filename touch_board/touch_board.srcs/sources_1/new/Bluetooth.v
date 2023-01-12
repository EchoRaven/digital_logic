module Bluetooth(
    input clk,//时钟
    input rst,//复位
    input get,//接受
    output reg [7:0] out//输出
);
    parameter bps=10417;//分频信号
    reg [14:0] first_count;//计数器1
    reg [3:0] second_count;//计数器2
    reg buffer[2:0];//除去滤波
    wire buffer_en;//检测到边沿
    reg add_en;//加法使能信号

    always @ (posedge clk)
    begin
        if(rst)
        begin
            buffer[0]<=1;
            buffer[1]<=1;
            buffer[2]<=1;
        end
        else
        begin
            buffer[0]<=get;
            buffer[1]<=buffer[0];
            buffer[2]<=buffer[1];
        end
    end

    assign buffer_en=buffer[2]&~buffer[1];

    always @ (posedge clk)
    begin
        if(rst)
        begin
            first_count<=0;
        end
        else if(add_en)
        begin
            if(first_count==bps-1)
            begin
                first_count<=0;
            end
            else
            begin
                first_count<=first_count+1;
            end
        end
    end

    always @ (posedge clk)
    begin
        if(rst)
        begin
            second_count<=0;
        end
        else if(add_en&&first_count==bps-1)//如果每一位加
        begin
            if(second_count==8)
            begin
                second_count<=0;
            end
            else
            begin
                second_count<=second_count+1;
            end
        end
    end

    always @ (posedge clk)
    begin
        if(rst)
        begin
            add_en<=0;
        end
        else if(buffer_en)
        begin
            add_en<=1;
        end
        else if(add_en&&second_count==8&&first_count==bps-1)
        begin
            add_en<=0;
        end
    end
    
    always @ (posedge clk)
    begin
        if(rst)
        begin
            out<=0;
        end
        else if(add_en&&first_count==bps/2-1&&second_count!=0)
        begin
            out[second_count-1]<=get;
        end
    end
    
endmodule