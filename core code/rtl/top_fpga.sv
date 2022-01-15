//(*dont_touch="yes"*)
module top_arima_anomaly_detection_with_memory (
    input clk,
    input start,
    input reset,
    
//    output [31:0] prediction,
//    output label,
//    output overflow,
//    output [31:0] time_step,    
    output logic [7:0] seg_in1,
    output logic [7:0] seg_in2
//    output logic [3:0] leds
);


    logic signed [31:0] memory_out;
    logic [31:0] addr_r;
    logic [31:0] addr_w;
    logic rden,wren;
    logic [31:0] prediction_o;
    logic divided_clk_50hz;
    logic divided_clk_1000hz;
    logic [3:0] leds;
    
//    logic [31:0] time_step;
    logic [31:0] prediction;
    logic overflow,label;
    logic [7:0] seven_seg;
    logic [7:0] seven_seg1;
    
    logic [31:0] addr;
    
    hex_to_seg hex_to_seg_dut1 (
        .hex(seven_seg),
        .clk(divided_clk_50hz),
        .seg(seg_in1)
    );
    
    hex_to_seg hex_to_seg_dut2 (
        .hex(seven_seg1),
        .clk(divided_clk_50hz),
        .seg(seg_in2)
    );

    ARIMA_anomaly_detection #(
    .Q(15),
	.N(32),
    .d_max(10),
    .p_max(10),
    .q_max(10)
    ) ARIMA_anomaly_detection_dut (
        .data_in(memory_out),
        .start(start),
        .reset(reset),
        .clk(divided_clk_1000hz),

        .prediction_o(prediction_o),
        .label(label),
        .address_r(addr_r),
        .rden(rden),
        .address_w(addr_w),
        .seven_seg(seven_seg),
        .seven_seg1(seven_seg1),
        .leds(leds),
        .wren(wren),
        .overflow(overflow)
    );

clock_driver clk_div_dut (
    .clk(clk),
    .divided_clk_50hz(divided_clk_50hz),
    .divided_clk_1000hz(divided_clk_1000hz)
);


//    fake_memory #(
//        .N(32)
//    ) mem_dut (
//        .address(addr_r),
//        .din(prediction_o),
//        .Rden(rden),
//        .Wren(wren),
//        .clk(divided_clk_1000hz),
//        .dout(memory_out)
//    );
    
    assign addr = wren?addr_w:addr_r;
    
    blk_mem_gen_0 mem_dut (
    .clka(divided_clk_1000hz),
    .ena(1'b1),
    .wea(1'b0),
    .addra(addr[10:0]),
    .dina(prediction_o),
    .douta(memory_out)
    );

endmodule

