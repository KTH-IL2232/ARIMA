//(*dont_touch="yes"*)
module ARIMA_anomaly_detection #(
    parameter Q = 15,
	parameter N = 32,
    parameter d_max = 10,
    parameter p_max = 10,
    parameter q_max = 10
)(
    input signed [N-1:0] data_in,
    input clk,
    input start,
    input reset,

    output [N-1:0] prediction_o,
    output label,
    output [N-1:0] address_r,
    output rden,
    output [N-1:0] address_w,
    output logic [7:0] seven_seg,
    output logic [7:0] seven_seg1,
    output logic [3:0] leds,
    output wren,
    output overflow
);

    // parameters needs to assign here
    logic [N-1:0] p_order=2;
    logic [N-1:0] d_order=1;
    logic [N-1:0] q_order=2;
    logic signed [N-1:0] ar_coef [0:p_max-1] = {32'b00000000000000000101010110110101,32'b11111111111111111110011000100101,0,0,0,0,0,0,0,0};
    logic signed [N-1:0] ma_coef [0:q_max-1] = {32'b00000000000000000101101101111000,32'b00000000000000000011000110100011,0,0,0,0,0,0,0,0};
    logic signed [N-1:0] cont=0;
    logic signed [N-1:0] kalman_beta=32'b00000000000000001111100110011001;
    logic signed [N-1:0] threshold = 32'b00000000000001010010011101101110;
    logic signed [N-1:0] mean = 32'b00000000000000000000010011101001;
    logic signed [N-1:0] variance = 32'b00000000000000000010011011011001;


    logic [1:0] c_diff;
    logic [1:0] c_ar;
    logic [1:0] c_ma;
    logic [1:0] c_inte;
    logic sel_inte_in;
    logic ready,init_mode;

    logic signed [N-1:0] prediction;
    logic signed [N-1:0] next_step_data;
    logic label_ad;
    logic signed [N-1:0] predictor_in;
    logic [N-1:0] current_time_step;

    assign predictor_in = init_mode?data_in:next_step_data;
    assign label = init_mode?1'b0:label_ad;
    assign prediction_o = {prediction[31:1],label};

    always_ff@(posedge clk) begin
        if (reset==1'b1) begin
            seven_seg<= 0;
            leds <= 0;
            seven_seg1 <= 0;
        end
        else
        if (label==1'b1) begin
            if(address_r <= 1000) begin
                seven_seg <= current_time_step[7:0];
                seven_seg1 <= current_time_step[15:8];
                leds <= current_time_step[11:8];
            end
        end
    end

    top_fsm #(
        .N(N)
    )
    fsm_dut
    (
        .p_order(p_order),
        .d_order(d_order),
        .q_order(q_order),
        .start(start),
        .reset(reset),
        .clk(clk),

        .c_diff(c_diff),
        .c_ar(c_ar),
        .c_ma(c_ma),
        .c_inte(c_inte),
        .sel_inte_in(sel_inte_in),
        .ready(ready),
        .address_r(address_r),
        .rden(rden),
        .address_w(address_w),
        .current_time_step(current_time_step),
        .wren(wren),
        .init_mode(init_mode)
    );

    data_path_n #(
        .Q(Q),
        .N(N),
        .d_max(d_max),
        .p_max(p_max),
        .q_max(q_max)
    )
    data_path_dut
    (
        .data_in(predictor_in),

        .c_diff(c_diff),
        .c_ar(c_ar),
        .c_ma(c_ma),
        .c_inte(c_inte),
        .sel_inte_in(sel_inte_in),
        .kalman_beta(kalman_beta),
        .p_order(p_order),
        .d_order(d_order),
        .q_order(q_order),
        .ar_coef(ar_coef),
        .ma_coef(ma_coef),
        .cont(cont),
        .clk(clk),
        .overflow(overflow),
        .data_out(prediction)
    );

    anomaly_detector #(
        .Q(Q),
        .N(N)
    )
    detector_dut
    (
        .observation(data_in),
        .prediction(prediction),
        .threshold(threshold),
        .mean(mean),
        .variance(variance),
        .reset(reset),
        .clk(clk),
        .ready(ready),

        .next_step_data(next_step_data),
        .label(label_ad)
    );

    
    
endmodule