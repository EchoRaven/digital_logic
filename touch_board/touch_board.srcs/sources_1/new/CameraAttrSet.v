module CameraAttrSet(
    input clk,
    input rst,
    output sio_c,
    inout sio_d,
    output reset,
    output pwdn,
    output xclk
);
    //拉低pwdn,拉高reset，表示正常启动
    assign reset=1;
    assign pwdn=0;
    //拉高sio_d的电阻
    pullup up (sio_d);
    //赋给xclk时钟信号 
    assign xclk=clk;
    //reg_state和sccb_state控制寄存器和恶sccb状态
    wire [15:0] data_send;
    wire reg_state,sccb_state;
    //初始化寄存器
    RegInit reginit(.clk(clk),.rst(rst),.data_out(data_send),.reg_state(reg_state),.sccb_state(sccb_state));
    //sccb传输配置信息
    Sccb sccb(.clk(clk),.rst(rst),.sio_d(sio_d),.sio_c(sio_c),.reg_state(reg_state),.sccb_state(sccb_state),.slave_id(8'h60),.reg_addr(data_send[15:8]),.value(data_send[7:0]));

endmodule