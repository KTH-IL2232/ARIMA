module data_path #(
	//Parameterized values
	parameter Q = 15,
	parameter N = 32
	)
    (
    input [1:0] c_diff,
    input [1:0] c_ar,
    input [1:0] c_ma,
    input [1:0] c_inte,
    input sel_inte_in,

    input signed [31:0] data_in,
    input [31:0] p_order,
    input [31:0] d_order,
    input [31:0] q_order,
    input signed [31:0] ar_coef [0:9],
    input signed [31:0] ma_coef [0:9],
    input signed [31:0] cont,
    input clk,

    output signed [31:0] data_out
);


    logic signed [31:0] diff_in;
    logic signed [31:0] ar_in;
    logic signed [31:0] ma_in;
    logic signed [31:0] inte_in;

    logic signed [31:0] diff_out;
    logic signed [31:0] ar_out;
    logic signed [31:0] ma_out;
    logic signed [31:0] inte_out;

    logic signed [31:0] initial_inte[0:9];
    logic init_inte;
    logic signed [31:0] diff_out_reg;

    logic signed [31:0] arma;

    // qadd #(.N(32),.Q(15))
    //     adder_1
    //     (.a_in(ar_out), 
    //     .b_in(ma_out),
    //     .c(arma));

    // qadd #(.N(32),.Q(15))
    //     adder_2
    //     (.a_in(ar_out), 
    //     .b_in({~diff_out[31],tscom(diff_out)[30:0]}),
    //     .c(ma_in)); // new sub module or more process

    

    assign diff_in = data_in;
    assign ar_in = diff_out;
    assign ma_in = ar_out + ma_out + cont - diff_out;
    assign inte_in = (sel_inte_in)?diff_out_reg:(ar_out + ma_out + cont);
    assign data_out = inte_out;

    always_ff @( posedge clk ) begin 
        diff_out_reg<=diff_out;
    end
    diff dut_df (
    .data_in(diff_in),
    .control(c_diff),
    .d_order_in(d_order),
    .clk(clk),
    .initial_inte(initial_inte),
    .init_inte(init_inte),
    .data_out(diff_out));

    ar dut_ar (
        .data_in(ar_in),
        .control(c_ar),
        .ar_coef_in(ar_coef),
        .p_order_in(p_order),
        .clk(clk),
        .data_out(ar_out)
    );

    ma dut_ma (
        .data_in(ma_in),
        .control(c_ma),
        .ma_coef_in(ma_coef),
        .q_order_in(q_order),
        .clk(clk),
        .data_out(ma_out)
    );

    inte dut_it (
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
