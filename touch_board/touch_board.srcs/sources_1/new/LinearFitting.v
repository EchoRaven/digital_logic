module LinearFitting(
        //摄像头对外接口
        output       sio_c,//摄像头sio_c信号
        inout        sio_d,//摄像头sio_d信号
        output       reset,//reset信号，需要拉高，否则会重置寄存器
        output       pwdn,//pwdn信号，拉低，关闭耗电模式
        output       xclk,//xclk信号，可不接
        input        pclk,href,vsync,//用于控制图像数据传输的三组信号
        input  [7:0] camera_data ,//图像数据信号
        
        //VGA对外接口
        output [3:0]  red_out,green_out,blue_out,//rgb像素信息
        output x_valid,//行时序信号
        output y_valid,//场时序信号
        input rst,//复位
        input clr,//vga初始化
        
        //时钟
        input  clk,//接板内时钟，100mhz
        
        //蓝牙端口
        input pmod,//接pmod
        
        //七位译码管
        output [6:0]display//输出
    );

    //时钟
    wire clk_vga ;//vga时钟 24mhz
    wire clk_init_reg;//初始化寄存器的时钟，25mhz
    clk_wiz_0 div(.clk_in1(clk),.clk_out1(clk_vga),.clk_out2(clk_init_reg));
    
    //蓝牙
    wire [7:0]out_bluetooth;//蓝牙数据输出
    Bluetooth bluetooth(.clk(clk),.rst(rst),.get(pmod),.out(out_bluetooth));

    //摄像机初始化
    wire [11:0] ramdata;//写数据
    wire  wr_en;//缓存写有效
    wire [18:0] ramaddr;//写地址
    CameraGetData cameragetdata(.rst(rst),.pclk(pclk),.href(href),.vsync(vsync),.data_in(camera_data),.data_out(ramdata),.wr_en(wr_en),.out_addr(ramaddr));
    CameraAttrSet cameraattrset(.clk(clk_init_reg),.sio_c(sio_c),.sio_d(sio_d),.reset(reset),.pwdn(pwdn),.rst(rst),.xclk(xclk));
    
    //数据处理和显示
    wire [11:0] rddata;//读数据
    wire [18:0] rdaddr;//读地址
    wire [11:0] binary_data;//二值化结果
    blk_mem_gen_0 buffer(.clka(clk),.ena(1),.wea(wr_en),.addra(ramaddr),.dina(ramdata),.clkb(clk),.enb(1),.addrb(rdaddr),.doutb(rddata));//数据储存
    Binarization binarization(.clk(clk),.rgb_data(rddata),.binary_data(binary_data));//二值化处理
    wire [3:0] choice;//选项显示
    VGA vga(.clk_vga(clk_vga),.rst(rst),.clr(clr),.color_data_in(binary_data),.ram_addr(rdaddr),.x_valid(x_valid),.y_valid(y_valid),.red(red_out),.green(green_out),.blue(blue_out),.bluetooth_data(out_bluetooth),.choice(choice));
    Display7 display7(.iData(choice),.oData(display));
endmodule
