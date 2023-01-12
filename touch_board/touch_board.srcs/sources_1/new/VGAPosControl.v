//���ڿ��Ƶ�ǰ��λ���źţ���֤�źſ�����ȷ��ʾ����ʾ������ȷλ��
module VGAPosControl(
    input vga_clk,//ʱ������
    input rst,//�����źţ��ߵ�ƽ��Ч
    output reg signed[11:0] x_poi,//�����ʱx������
    output reg signed[11:0] y_poi,//�����ʱy������
    output is_display,//������ʱ�Ƿ��ܹ����
    output x_valid,//����Ч�ź�`
    output y_valid//����Ч�ź�
);
    //�в���
    parameter x_sync=11'd96;
    parameter x_before=11'd144;
    parameter x_beside_after=11'd784;
    parameter x_all=11'd799;
    //�в���
    parameter y_sync=11'd2;
    parameter y_before=11'd35;
    parameter y_beside_after=11'd515;
    parameter y_all=11'd524;
    
    assign is_display=((x_poi>=x_before)&&(x_poi<x_beside_after)
    &&(y_poi>=y_before)&&(y_poi<y_beside_after))?1:0;
    
    assign x_valid=(x_poi<x_sync)?0:1;//��ͬ���ź�����ʱ��
    assign y_valid=(y_poi<y_sync)?0:1;//��ͬ���ź�����ʱ��
    
    always @ (posedge vga_clk)//�жϴ�ʱ�Ƿ���Խ��л���ͼ��
    begin
        if(rst)//�����ź�
        begin
            x_poi<=0;
            y_poi<=0;
        end
        else
        begin
            if(x_poi==x_all)
            begin
                x_poi<=0;
                if(y_poi==y_all)
                begin
                    y_poi<=0;
                end
                else
                begin
                    y_poi<=y_poi+1;
                end
            end
            else
            begin
                x_poi<=x_poi+1;
            end
        end
    end
endmodule