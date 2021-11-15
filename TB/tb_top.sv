module tb_top (
);


    bit clk=1'b1;
    always #5 clk= ~clk;

    logic [31:0] p_order_in,d_order_in,q_order_in,cont_in;
    logic signed [31:0] data;
    logic start,reset;
    logic signed [31:0] ar_coef_in [0:9];
    logic signed [31:0] ma_coef_in [0:9];

    logic [31:0] p_order;
    logic [31:0] d_order;
    logic [31:0] q_order;
    logic signed [31:0] ar_coef [0:9];
    logic signed [31:0] ma_coef [0:9];
    logic [31:0] cont;

    logic [1:0] c_diff;
    logic [1:0] c_ar;
    logic [1:0] c_ma;
    logic [1:0] c_inte;
    logic sel_inte_in;

    logic [31:0] output_data;

    logic [31:0] test_data = 32'b1_1111_1111_1111_1111_0000_0000_0000_0000;


    control_unit control_unit_dut(
        .data_in(data),
        .p_order_in(p_order_in),
        .d_order_in(d_order_in),
        .q_order_in(q_order_in),
        .ar_coef_in(ar_coef_in),
        .ma_coef_in(ma_coef_in),
        .cont_in(cont_in),
        .start(start),
        .rst(reset),
        .clk(clk),

        .c_diff(c_diff),
        .c_ar(c_ar),
        .c_ma(c_ma),
        .c_inte(c_inte),
        .sel_inte_in(sel_inte_in),
        .p_order(p_order),
        .d_order(d_order),
        .q_order(q_order),
        .ar_coef(ar_coef),
        .ma_coef(ma_coef),
        .cont(cont)
    );


    


    data_path data_path_dut(
        .c_diff(c_diff),
        .c_ar(c_ar),
        .c_ma(c_ma),
        .c_inte(c_inte),
        .sel_inte_in(sel_inte_in),
        .data_in(data),
        .p_order(p_order),
        .d_order(d_order),
        .q_order(q_order),
        .ar_coef(ar_coef),
        .ma_coef(ma_coef),
        .cont(cont),
        .clk(clk),

        .data_out(output_data)
    );
    

    parameter FILE_PATH_r   = "/testdata/1.csv";
    parameter FILE_PATH_w   = "/testdata/2.txt";
    reg [31:0] dat_r [0:2000];
    integer j=0;
    reg [31:0] dat_w [0:2000];
    

    always_ff @( posedge clk ) begin : mem_w
        j<=j+1;
        if(j>=5) begin
            dat_w[j-5]<=output_data;
        end
    end

    always_comb begin : mem_r
        data = (j>=2)?dat_r[j-2]:0;
    end

    real r_data_in,r_ar_out,r_diff_out,r_ma_in,r_ma_out,r_inte_in,r_data_out;
    real fp=2.0**-15;
    always_comb begin 
        r_data_in = (data*fp);
        r_diff_out = ((data_path_dut.diff_out)*fp);
        r_ar_out = ((data_path_dut.ar_out)*fp);
        r_ma_in = ((data_path_dut.ma_in)*fp);
        r_ma_out = ((data_path_dut.ma_out)*fp);
        r_inte_in = ((data_path_dut.inte_in)*fp);
        r_data_out = ((data_path_dut.data_out)*fp);
    end

    initial begin
        int fid;
        $readmemb( FILE_PATH_r, dat_r, 0 );
        for(int i=0; i<1000; i++ ) begin
            $display("%b\n", dat_r[i]);
        end
        p_order_in = 2;
        d_order_in = 1;
        q_order_in = 2;
        ar_coef_in = {32'b00000000000000000110000000000000,32'b00000000000000000001100110011001,0,0,0,0,0,0,0,0};
        ma_coef_in = {32'b00000000000000000100000000000000,32'b11111111111111111110011001100111,0,0,0,0,0,0,0,0};
        cont_in = 0;
        start = 0;
        reset = 1;
        @(posedge clk);
        start = 1;
        reset = 0;
        @(posedge clk);
        start = 0;
        #10ns;
        // $writememb(FILE_PATH_w, dat_w, 0);
        fid = $fopen(FILE_PATH_w, "w");
        $fwrite(fid, "data,\n");
        for( int i=0; i<999; i++ ) begin
            $fwrite(fid, "\"0b%b\",\n", dat_w[i]);
        end 
        $fclose(fid);
    end

endmodule
