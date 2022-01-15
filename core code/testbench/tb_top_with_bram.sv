module new_tb_ad_with_bram (
);
    bit clk=1'b1;
    always #4 clk= ~clk;


    logic start,reset;
//    logic [31:0] prediction;
//    logic [31:0] time_step;
//    logic label,overflow;
    logic [7:0] seg_in;
    logic [3:0] leds;

//    top_arima_anomaly_detection_with_memory dut (
//        .clk(clk),
//        .start(start),
//        .reset(reset),

//        .prediction(prediction),
//        .label(label),
//        .overflow(overflow),
//        .time_step(time_step),
//        .seg_in(seg_in)
//    );
    
    top_arima_anomaly_detection_with_memory dut (
        .clk(clk),
        .start(start),
        .reset(reset),

        .seg_in(seg_in),
        .leds(leds)
    );


    initial begin
        reset = 1'b1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);   
        reset = 1'b0;
        start = 1'b1;
        @(posedge clk);
    end
endmodule

