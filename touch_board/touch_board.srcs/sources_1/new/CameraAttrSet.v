module CameraAttrSet(
    input clk,
    input rst,
    output sio_c,
    inout sio_d,
    output reset,
    output pwdn,
    output xclk
);
    //����pwdn,����reset����ʾ��������
    assign reset=1;
    assign pwdn=0;
    //����sio_d�ĵ���
    pullup up (sio_d);
    //����xclkʱ���ź� 
    assign xclk=clk;
    //reg_state��sccb_state���ƼĴ����Ͷ�sccb״̬
    wire [15:0] data_send;
    wire reg_state,sccb_state;
    //��ʼ���Ĵ���
    RegInit reginit(.clk(clk),.rst(rst),.data_out(data_send),.reg_state(reg_state),.sccb_state(sccb_state));
    //sccb����������Ϣ
    Sccb sccb(.clk(clk),.rst(rst),.sio_d(sio_d),.sio_c(sio_c),.reg_state(reg_state),.sccb_state(sccb_state),.slave_id(8'h60),.reg_addr(data_send[15:8]),.value(data_send[7:0]));

endmodule