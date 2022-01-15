module ma_n #(
    parameter Q = 15,
	parameter N = 32,
    parameter q_max = 10
)(
    input signed [N-1:0] data_in,
    input [1:0] control,
    input signed [N-1:0] ma_coef_in [0:q_max-1],
    input [N-1:0] q_order_in,
    input clk,

    output logic overflow,
    output signed [N-1:0] data_out
);

    logic signed [N-1:0] n_data [0:q_max-1]; // 0
    logic [N-1:0] q_order;
    logic signed [N-1:0] ma_coef [0:q_max-1];

    logic signed [N-1:0] dout;
    logic signed [N-1:0] mul [0:q_max-1];
    logic signed [N-1:0] mac_res [0:q_max];
    logic over [0:q_max-1];
    logic [0:q_max-1] over_packed;

    logic init;

    always_comb begin : over_or
        for (int i = 0; i<q_max ;i++ ) begin
            over_packed[i] <= over[i];
        end
        overflow = |over_packed;
    end

    assign data_out = mac_res[q_order];
    assign mac_res[0] = 0;
    assign q_order = q_order_in;
    assign ma_coef = ma_coef_in;

    qmult #(.N(N),.Q(Q))
    mults[0:q_max-1]
    (
        .i_multiplicand(n_data), 
        .i_multiplier(ma_coef),
        .o_result(mul),
        .ovr(over));

    generate
        genvar i;
        for (i=0; i<q_max-1; i=i+1) begin : adders
            qadd #(.N(32),.Q(15))
            adder
            (
            .a_in(mac_res[i]), 
            .b_in(mul[i]),
            .c(mac_res[i+1]));
        end
    endgenerate


    always_ff @( posedge clk ) begin : ma_main
        case(control)
            2'b00: begin // normal working mode
                n_data[0] <= data_in;
                for (int i = 1; i<q_max ;i++ ) begin
                    n_data[i] <= n_data[i-1];
                end
            end
            2'b01: begin // stall mode
                
            end
            2'b10: begin // initialize mode

            end
            2'b11: begin // reset all registers
                for (int i = 0; i<q_max;i++ ) begin
                    n_data[i] <= 0;
                end
                dout <= 0;
            end
        endcase
    end
    
endmodule

