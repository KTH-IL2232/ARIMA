module new_tb_ad (
);
    bit clk=1'b1;
    always #5 clk= ~clk;


    logic signed [31:0] memory_in;
    logic signed [31:0] memory_out;
    logic start,reset;
    logic [31:0] addr_r;
    logic [31:0] addr_w;
    logic rden,wren;
    logic label,overflow;

    real r_predictor_in,r_prediction_in,r_observation_in,r_next_step_data,r_memory_out,r_memory_in,r_ar_out,r_diff_out,r_ma_in,r_ma_out,r_inte_in,r_data_out;
    real fp=2.0**-15;
    always_comb begin 
        r_memory_out = (memory_out*fp);
        r_predictor_in = (ARIMA_anomaly_detection_dut.predictor_in)*fp;
        r_diff_out = ((ARIMA_anomaly_detection_dut.data_path_dut.diff_out)*fp);
        r_ar_out = ((ARIMA_anomaly_detection_dut.data_path_dut.ar_out)*fp);
        r_ma_in = ((ARIMA_anomaly_detection_dut.data_path_dut.ma_in)*fp);
        r_ma_out = ((ARIMA_anomaly_detection_dut.data_path_dut.ma_out)*fp);
        r_inte_in = ((ARIMA_anomaly_detection_dut.data_path_dut.inte_in)*fp);
        r_data_out = ((ARIMA_anomaly_detection_dut.data_path_dut.data_out)*fp);
        r_memory_in = memory_in*fp;
        r_next_step_data = ARIMA_anomaly_detection_dut.next_step_data*fp;
        r_prediction_in = ARIMA_anomaly_detection_dut.prediction*fp;
        r_observation_in = ARIMA_anomaly_detection_dut.data_in*fp;
    end

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
        .clk(clk),

        .prediction_o(memory_in),
        .label(label),
        .address_r(addr_r),
        .rden(rden),
        .address_w(addr_w),
        .wren(wren),
        .overflow(overflow)
    );




    fake_memory #(
        .N(32)
    ) mem_dut (
        .address(addr_r),
        .din(memory_in),
        .Rden(rden),
        .Wren(wren),
        .clk(clk),
        .dout(memory_out)
    );

    initial begin
        reset = 1'b1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        reset = 1'b0;
        start = 1'b1;
        @(posedge clk);
    end

endmodule

