module ar_n #(
    parameter Q = 15,
	parameter N = 32,
    parameter p_max = 10
)(
    input signed [N-1:0] data_in,
    input [1:0] control,
    input signed [N-1:0] ar_coef_in [0:p_max-1],
    input [N-1:0] p_order_in,
    input clk,

    output logic overflow,
    output signed [N-1:0] data_out
);

    logic signed [N-1:0] n_data [0:p_max-1]; // 0
    logic [N-1:0] p_order;
    logic signed [N-1:0] ar_coef [0:p_max-1];

    logic signed [N-1:0] dout;
    logic signed [N-1:0] mul [0:p_max-1];
    logic signed [N-1:0] mac_res [0:p_max];
    logic over [0:p_max-1];
    logic [0:p_max-1] over_packed;


    assign data_out = dout;
    assign mac_res[0] = 0;
    assign ar_coef = ar_coef_in;
    assign p_order = p_order_in;

    always_comb begin : over_or
        for (int i = 0; i<p_max ;i++ ) begin
            over_packed[i] <= over[i];
        end
        overflow = |over_packed;
    end

    qmult #(.N(N),.Q(Q))
    mults[0:p_max-1]
    (
        .i_multiplicand(n_data), 
        .i_multiplier(ar_coef),
        .o_result(mul),
        .ovr(over));

    generate
        genvar i;
        for (i=0; i<p_max-1; i=i+1) begin : adders
            qadd #(.N(32),.Q(15))
            adder
            (
            .a_in(mac_res[i]), 
            .b_in(mul[i]),
            .c(mac_res[i+1]));
        end
    endgenerate

    always_ff @( posedge clk ) begin : ar_main
        case(control)
            2'b00: begin // normal working mode
                dout <= mac_res[p_order]; // output register for intilize correctness,ma do not have
                n_data[0] <= data_in;
                for (int i = 1; i<p_max ;i++ ) begin
                    n_data[i] <= n_data[i-1];
                end
            end
            2'b01: begin // stall mode
                
            end
            2'b10: begin // initialize mode

            end
            2'b11: begin // reset all registers
                for (int i = 0; i<10 ;i++ ) begin
                    n_data[i] <= 0;
                end
                dout <= 0;
            end
        endcase
    end
    
endmodule
