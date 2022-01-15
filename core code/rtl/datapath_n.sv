module data_path_n #(
	//Parameterized values
	parameter Q = 15,
	parameter N = 32,
    parameter d_max = 10,
    parameter p_max = 10,
    parameter q_max = 10
	)(
    input signed [N-1:0] data_in,

    input [1:0] c_diff,
    input [1:0] c_ar,
    input [1:0] c_ma,
    input [1:0] c_inte,
    input sel_inte_in,

    input signed [N-1:0] kalman_beta,
    input [N-1:0] p_order,
    input [N-1:0] d_order,
    input [N-1:0] q_order,
    input signed [N-1:0] ar_coef [0:p_max-1],
    input signed [N-1:0] ma_coef [0:q_max-1],
    input signed [N-1:0] cont,
    input clk,

    output signed overflow,
    output signed [N-1:0] data_out
);


    logic signed [N-1:0] diff_in;
    logic signed [N-1:0] ar_in;
    logic signed [N-1:0] ma_in;
    logic signed [N-1:0] inte_in;

    logic signed [N-1:0] diff_out;
    logic signed [N-1:0] ar_out;
    logic signed [N-1:0] ma_out;
    logic signed [N-1:0] inte_out;

    logic signed [N-1:0] initial_inte[0:d_max-1];
    logic init_inte;
    logic signed [N-1:0] diff_out_reg;

    logic signed [N-1:0] arma;
    logic signed [N-1:0] arma_kal;

    logic o_ar,o_ma,o_kal;
    

    assign diff_in = data_in;
    assign ar_in = diff_out;
    assign arma = ar_out + ma_out + cont;

    qmult #(.N(N),.Q(Q))
    mult
    (
        .i_multiplicand(arma), 
        .i_multiplier(kalman_beta),
        .o_result(arma_kal),
        .ovr(o_kal));

    assign ma_in = diff_out - arma_kal;
    assign inte_in = (sel_inte_in)?diff_out:arma_kal;
    assign data_out = inte_out;


    assign overflow = o_ar||o_ma||o_kal;

    always_ff @( posedge clk ) begin 
        diff_out_reg<=diff_out;
    end
    diff_n #(
        .Q(Q),
        .N(N),
        .d_max(d_max)
    )
    dut_df(
    .data_in(diff_in),
    .control(c_diff),
    .d_order_in(d_order),
    .clk(clk),
    .initial_inte(initial_inte),
    .init_inte(init_inte),
    .data_out(diff_out));

    ar_n #(
        .Q(Q),
        .N(N),
        .p_max(p_max)
    )
    dut_ar (
        .data_in(ar_in),
        .control(c_ar),
        .ar_coef_in(ar_coef),
        .p_order_in(p_order),
        .clk(clk),
        .overflow(o_ar),
        .data_out(ar_out)
    );

    ma_n #(
        .Q(Q),
        .N(N),
        .q_max(q_max)
    )
    dut_ma(
        .data_in(ma_in),
        .control(c_ma),
        .ma_coef_in(ma_coef),
        .q_order_in(q_order),
        .clk(clk),
        .overflow(o_ma),
        .data_out(ma_out)
    );

    inte_n #(
        .Q(Q),
        .N(N),
        .d_max(d_max)
    )
    dut_it (
    .data_in(inte_in),
    .control(c_inte),
    .d_order_in(d_order),
    .initial_inte(initial_inte),
    .init_inte(init_inte),
    .clk(clk),
    .data_out(inte_out));

    function [N-1:0] tscom;
        input [N-1:0] data;
        begin
            tscom[N-1] = data[N-1];
            if (data[N-1]==1'b1)
            tscom[N-2:0] = ~data[N-2:0] + 1;
            else
            tscom[N-2:0] = data[N-2:0];
        end
        
    endfunction
endmodule
