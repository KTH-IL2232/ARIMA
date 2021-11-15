module ma (
    input signed [31:0] data_in,
    input [1:0] control,
    input signed [31:0] ma_coef_in [0:9],
    input [31:0] q_order_in,
    input clk,
    output signed [31:0] data_out
);

    logic signed [31:0] n_data [0:9]; // 0
    logic [31:0] q_order;
    logic signed [31:0] ma_coef [0:9];

    logic signed [31:0] dout;
    logic signed [31:0] mul [0:9];
    logic signed [31:0] mac_res [0:10];
    logic [31:0] cnt_i;
    logic over [0:9];

    logic init;

    // assign data_out = dout;
    assign data_out = mac_res[q_order];
    assign mac_res[0] = 0;

    // qmult #(.N(32),.Q(15))
    // mult_1
    // (
    //     .i_multiplicand(data_in), 
    //     .i_multiplier(ma_coef[0]),
    //     .o_result(mul[0]),
    //     .ovr(over[0]));

    // qmult #(.N(32),.Q(15))
    // mults[0:8]
    // (
    //     .i_multiplicand(n_data), 
    //     .i_multiplier(ma_coef[1:9]),
    //     .o_result(mul[1:9]),
    //     .ovr(over[1:9]));

    // generate
    //     genvar i;
    //     for (i=0; i<9; i=i+1) begin : adders
    //         qadd #(.N(32),.Q(15))
    //         adder
    //         (
    //         .a_in(mac_res[i]), 
    //         .b_in(mul[i]),
    //         .c(mac_res[i+1]));
    //     end
    // endgenerate

    qmult #(.N(32),.Q(15))
    mults[0:9]
    (
        .i_multiplicand(n_data), 
        .i_multiplier(ma_coef),
        .o_result(mul),
        .ovr(over));

    generate
        genvar i;
        for (i=0; i<9; i=i+1) begin : adders
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
                // dout <= mac_res[q_order];
                n_data[0] <= data_in;
                for (int i = 1; i<10 ;i++ ) begin
                    n_data[i] <= n_data[i-1];
                end
            end
            2'b01: begin // stall mode
                
            end
            2'b10: begin // initialize mode
                if (init==0) begin
                    init <= 1;
                    q_order <= q_order_in;
                    ma_coef <= ma_coef_in;
                    cnt_i <= q_order_in - 1;
                end
                // else if(cnt_i!=0) begin
                //     n_data[0] <= data_in;
                //     for (int i = 1; i<10 ;i++ ) begin
                //         n_data[i] <= n_data[i-1];
                //     end
                //     cnt_i <= cnt_i - 1;
                // end
                // else begin
                //     n_data[0] <= data_in;
                //     for (int i = 1; i<10 ;i++ ) begin
                //         n_data[i] <= n_data[i-1];
                //     end
                //     init <= 0;
                // end
            end
            2'b11: begin // reset all registers
                for (int i = 0; i<10 ;i++ ) begin
                    ma_coef[i] <= 0;
                    n_data[i] <= 0;
                end
                q_order <= 0;
                cnt_i <= 0;
                dout <= 0;
                init <= 1'b0;
            end
        endcase
    end
    
endmodule

