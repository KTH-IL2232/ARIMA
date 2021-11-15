module inte(
    input signed [31:0] data_in,
    input [1:0] control,// 2'b00 = working; 2'b01 = stall; 2'b10 = init; 2'b11 = clear
    input [31:0] d_order_in,
    input init_inte,
    input signed [31:0] initial_inte[0:9],
    input clk,
    output signed [31:0] data_out
);

    logic signed [31:0] n_diff [0:9];
    logic signed [31:0] sum;

    assign data_out = n_diff[0];


    always_ff @( posedge clk ) begin : inte_main
        case(control)
            2'b00: begin // normal working mode
                n_diff[d_order_in] <= data_in;
                for (int i = 0; i<=9;i++) begin
                    sum = 0;
                    for(int j = 9; j>=i;j--) begin
                        if (j!=d_order_in)
                            sum += n_diff[j];
                        else
                            sum += data_in;
                    end 
                    n_diff[i] <= sum;
                end
            end
            2'b01: begin // stall mode
                
            end
            2'b10: begin // initialize mode
                if(init_inte==1'b1) begin
                    n_diff <= initial_inte;
                end
            end
            2'b11: begin // reset all registers
                sum <= 0;
                for (int i = 0; i<10 ;i++ ) begin
                    n_diff[i] <= 0;
                end
            end
        endcase
    end
    
endmodule