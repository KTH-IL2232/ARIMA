module inte_n
#(
    parameter Q = 15,
	parameter N = 32,
    parameter d_max = 10
)(
    input signed [N-1:0] data_in,
    input [1:0] control,// 2'b00 = working; 2'b01 = stall; 2'b10 = init; 2'b11 = clear
    input [N-1:0] d_order_in,
    input init_inte, // control signal from diff to get the intial value
    input signed [N-1:0] initial_inte[0:d_max-1],
    input clk,
    output signed [N-1:0] data_out
);

    logic signed [N-1:0] n_diff [0:d_max-1];
    logic signed [N-1:0] sum;

    assign data_out = n_diff[0];


    always_ff @( posedge clk ) begin : inte_main
        case(control)
            2'b00: begin // normal working mode
                n_diff[d_order_in] <= data_in;
                for (int i = 0; i<=d_max-1;i++) begin
                    sum = 0;
                    for(int j = d_max-1; j>=i;j--) begin
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
                    for (int i = 0;i<1;i++) begin
                        n_diff[i] <= initial_inte[i];
                    end
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