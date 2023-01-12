module VGA(
    input clk_vga,//����vga��ʱ�ӣ�Ƶ��Ϊ25.175MHz
    input rst,//��λ�źţ��ߵ�ƽ��Ч
    input clr,
    input [11:0] color_data_in,//��RAM�ж�ȡ��������Ϣ
    output reg[18:0] ram_addr,//Ӧ�ö�ȡ��RAM��ͼƬ��ַ����vga_control����
    output x_valid,
    output y_valid,
    output reg[3:0] red,
    output reg[3:0] blue,
    output reg[3:0] green,
    input [7:0] bluetooth_data,
    output reg[3:0] choice
);
    parameter x_before=11'd144;
    parameter y_before=11'd35;
    parameter x_size_pic=11'd640;
    parameter y_size_pic=11'd480;
    parameter x_all=11'd799;
    parameter y_all=11'd524;
    integer dis=40;
    
    wire signed [11:0] x_poi;//�����ʱx������
    wire signed [11:0] y_poi;//�����ʱy������
    wire is_display;//������ʱ�Ƿ��ܹ����
    integer x_sum;//x�ĺ�
    integer y_sum;//y�ĺ�
    integer xx_sum;//x^2�ĺ�
    integer num;//����
    integer xy_sum;//xy�ĺ�
    integer k_up;//б�ʷ���
    integer k_down;//б�ʷ�ĸ
    integer b_up;//�ؾ����
    integer b_down;//�ؾ��ĸ
    integer x;//x
    integer y;//y
    reg [3:0] cr,cg,cb;//������ɫ
    VGAPosControl vgaposcontrol(clk_vga,rst,x_poi,y_poi,is_display,x_valid,y_valid);
    always@ (bluetooth_data)
    begin
        if(bluetooth_data==0)
        begin
            cr=0;
            cg=0;
            cb=15;
            dis=40;
        end
        else if(bluetooth_data==1)
        begin
            cr=cr;
            cg=cg;
            cb=cb;
            dis=30;
        end
        else if(bluetooth_data==2)
        begin
            cr=cr;
            cg=cg;
            cb=cb;
            dis=40;
        end
        else if(bluetooth_data==3)
        begin
            cr=cr;
            cg=cg;
            cb=cb;
            dis=50;
        end
        else if(bluetooth_data==4)
        begin
            cr=cr;
            cg=cg;
            cb=cb;
            dis=60;
        end
        else if(bluetooth_data==5)
        begin
            cr=cr;
            cg=cg;
            cb=cb;
            dis=70;
        end
        else if(bluetooth_data==6)
        begin
            cr=15;
            cg=0;
            cb=0;
            dis=dis;
        end
        else if(bluetooth_data==7)
        begin
            cr=0;
            cg=15;
            cb=0;
            dis=dis;
        end
        else if(bluetooth_data==8)
        begin
            cr=0;
            cg=0;
            cb=15;
            dis=dis;
        end
        else
        begin
            cr=cr;
            cg=cg;
            cb=cb;
            dis=dis;     
        end
    end
    
    always@ (posedge clk_vga)
    begin
        if(clr==1)
        begin
            x_sum=0;
            y_sum=0;
            xx_sum=0;
            xy_sum=0;
            num=0;
            x=0;
            y=0;
            k_up=1;
            k_down=1;
            b_up=0;
            b_down=0;
        end
        else
        begin
            x=x_poi;
            y=y_poi;
            if((x!=x_all) || (y!=y_all))
            begin
                if(color_data_in[3:0]==0 && x%dis==0 && y%dis==0)
                begin
                    x_sum=x_sum+x/dis;
                    y_sum=y_sum+y/dis;
                    xx_sum=xx_sum+(x/dis)*(x/dis);
                    xy_sum=xy_sum+(x/dis)*(y/dis);
                    num=num+1;
                end
            end
            else
            begin
                k_up=xy_sum*num-x_sum*y_sum;
                k_down=xx_sum*num-x_sum*x_sum;
                b_up=(y_sum*xx_sum-x_sum*xy_sum)*dis;
                b_down=xx_sum*num-x_sum*x_sum;  
                choice=bluetooth_data;   
                num=0;
                x_sum=0;
                y_sum=0;
                xx_sum=0;
                xy_sum=0;
            end
        end
    end
    
    always@ (*)
    begin
        red=0;
        blue=0;
        green=0;
        if(is_display)
        begin
            if(x_poi-x_before<=x_size_pic&&y_poi-y_before<=y_size_pic)
            begin
                red=color_data_in[11:8];
                green=color_data_in[7:4];
                blue=color_data_in[3:0];
                ram_addr=(y_poi-y_before)*x_size_pic+(x_poi-x_before);
                x=x_poi;
                y=y_poi;
                if(k_down>0)
                begin
                    if(x*k_up+b_up<=(y+5)*k_down && x*k_up+b_up>=(y-5)*k_down)
                    begin
                        red=15;
                        green=0;
                        blue=0;
                    end
                end
                else
                begin
                    if(x*k_up+b_up<=(y-5)*k_down && x*k_up+b_up>=(y+5)*k_down)
                    begin
                        red=15;
                        green=0;
                        blue=0;
                    end
                end 
                if(x%dis==0 || y%dis==0)
                begin
                    red=cr;
                    green=cg;
                    blue=cb;
                end       
            end
            else
            begin
                red=0;
                green=0;
                blue=0;
            end
        end
    end
endmodule