module anomaly_detector  #(
	//Parameterized values
	parameter Q = 15,
	parameter N = 32
	)(
    input signed [N-1:0] observation,
    input signed [N-1:0] prediction,
    input signed [N-1:0] threshold,
    input signed [N-1:0] mean,
    input signed [N-1:0] variance,
    // input control,
    input reset,
    input clk,
    input ready,

    output logic signed [N-1:0] next_step_data,
    output logic label
);
    logic overflow,o1,o2;
    logic signed [N-1:0] error;
    logic signed [N-1:0] t1,t2;
    logic signed [N-1:0] ac;

    assign overflow = o1 | o2;
    always_comb begin : anomaly_score
        error = observation - prediction;
        t1 = (error-mean);
    end 

    qmult #(.N(N),.Q(Q))
    mult1
    (
        .i_multiplicand(t1), 
        .i_multiplier(t1),
        .o_result(t2),
        .ovr(o1));

    qmult #(.N(N),.Q(Q))
    mult2
    (
        .i_multiplicand(t2), 
        .i_multiplier(variance),
        .o_result(ac),
        .ovr(o2));


    always_ff @( posedge clk ) begin 
        if (reset==1'b1) begin
            label <= 1'b0;
            next_step_data <= 0;
        end
        else begin
            if (ready==1'b1) begin
                if (ac>threshold) begin
                    next_step_data <= prediction;
                    label <= 1'b1;
                end
                else begin
                    next_step_data <= observation;
                    label <= 1'b0;
                end
        end
        end
    end


endmodule
