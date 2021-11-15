module ar (
    input signed [31:0] data_in,
    input [1:0] control,
    input signed [31:0] ar_coef_in [0:9],
    input [31:0] p_order_in,
    input clk,
    output signed [31:0] data_out
);

    logic signed [31:0] n_data [0:9]; // 0
    logic [31:0] p_order;
    logic signed [31:0] ar_coef [0:9];

    logic signed [31:0] dout;
    logic signed [31:0] mul [0:9];
    logic signed [31:0] mac_res [0:10];
    logic [31:0] cnt_i;
    logic over [0:9];

    logic init;

    assign data_out=dout;
    assign mac_res[0]=0;
    qmult #(.N(32),.Q(15))
    mults[0:9]
    (
        .i_multiplicand(n_data), 
        .i_multiplier(ar_coef),
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

    always_ff @( posedge clk ) begin : ar_main
        case(control)
            2'b00: begin // normal working mode
                dout <= mac_res[p_order];
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
                    p_order <= p_order_in;
                    ar_coef <= ar_coef_in;
                    cnt_i <= p_order_in - 1;
                end
                else if(cnt_i!=0) begin
                    n_data[0] <= data_in;
                    for (int i = 1; i<10 ;i++ ) begin
                        n_data[i] <= n_data[i-1];
                    end
                    cnt_i <= cnt_i - 1;
                end
                else begin
                    n_data[0] <= data_in;
                    for (int i = 1; i<10 ;i++ ) begin
                        n_data[i] <= n_data[i-1];
                    end
                    init <= 0;
                end
            end
            2'b11: begin // reset all registers
                for (int i = 0; i<10 ;i++ ) begin
                    ar_coef[i] <= 0;
                    n_data[i] <= 0;
                end
                p_order <= 0;
                cnt_i <= 0;
                dout <= 0;
                init <= 1'b0;
            end
        endcase
    end
    
endmodule
