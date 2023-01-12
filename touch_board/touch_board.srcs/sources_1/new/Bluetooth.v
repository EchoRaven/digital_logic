module Bluetooth(
    input clk,//ʱ��
    input rst,//��λ
    input get,//����
    output reg [7:0] out//���
);
    parameter bps=10417;//��Ƶ�ź�
    reg [14:0] first_count;//������1
    reg [3:0] second_count;//������2
    reg buffer[2:0];//��ȥ�˲�
    wire buffer_en;//��⵽����
    reg add_en;//�ӷ�ʹ���ź�

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
        else if(add_en&&first_count==bps-1)//���ÿһλ��
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