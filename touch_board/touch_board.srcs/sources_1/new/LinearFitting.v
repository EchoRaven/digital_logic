module LinearFitting(
        //����ͷ����ӿ�
        output       sio_c,//����ͷsio_c�ź�
        inout        sio_d,//����ͷsio_d�ź�
        output       reset,//reset�źţ���Ҫ���ߣ���������üĴ���
        output       pwdn,//pwdn�źţ����ͣ��رպĵ�ģʽ
        output       xclk,//xclk�źţ��ɲ���
        input        pclk,href,vsync,//���ڿ���ͼ�����ݴ���������ź�
        input  [7:0] camera_data ,//ͼ�������ź�
        
        //VGA����ӿ�
        output [3:0]  red_out,green_out,blue_out,//rgb������Ϣ
        output x_valid,//��ʱ���ź�
        output y_valid,//��ʱ���ź�
        input rst,//��λ
        input clr,//vga��ʼ��
        
        //ʱ��
        input  clk,//�Ӱ���ʱ�ӣ�100mhz
        
        //�����˿�
        input pmod,//��pmod
        
        //��λ�����
        output [6:0]display//���
    );

    //ʱ��
    wire clk_vga ;//vgaʱ�� 24mhz
    wire clk_init_reg;//��ʼ���Ĵ�����ʱ�ӣ�25mhz
    clk_wiz_0 div(.clk_in1(clk),.clk_out1(clk_vga),.clk_out2(clk_init_reg));
    
    //����
    wire [7:0]out_bluetooth;//�����������
    Bluetooth bluetooth(.clk(clk),.rst(rst),.get(pmod),.out(out_bluetooth));

    //�������ʼ��
    wire [11:0] ramdata;//д����
    wire  wr_en;//����д��Ч
    wire [18:0] ramaddr;//д��ַ
    CameraGetData cameragetdata(.rst(rst),.pclk(pclk),.href(href),.vsync(vsync),.data_in(camera_data),.data_out(ramdata),.wr_en(wr_en),.out_addr(ramaddr));
    CameraAttrSet cameraattrset(.clk(clk_init_reg),.sio_c(sio_c),.sio_d(sio_d),.reset(reset),.pwdn(pwdn),.rst(rst),.xclk(xclk));
    
    //���ݴ������ʾ
    wire [11:0] rddata;//������
    wire [18:0] rdaddr;//����ַ
    wire [11:0] binary_data;//��ֵ�����
    blk_mem_gen_0 buffer(.clka(clk),.ena(1),.wea(wr_en),.addra(ramaddr),.dina(ramdata),.clkb(clk),.enb(1),.addrb(rdaddr),.doutb(rddata));//���ݴ���
    Binarization binarization(.clk(clk),.rgb_data(rddata),.binary_data(binary_data));//��ֵ������
    wire [3:0] choice;//ѡ����ʾ
    VGA vga(.clk_vga(clk_vga),.rst(rst),.clr(clr),.color_data_in(binary_data),.ram_addr(rdaddr),.x_valid(x_valid),.y_valid(y_valid),.red(red_out),.green(green_out),.blue(blue_out),.bluetooth_data(out_bluetooth),.choice(choice));
    Display7 display7(.iData(choice),.oData(display));
endmodule
