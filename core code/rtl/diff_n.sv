module diff_n 
#(
    parameter Q = 15,
	parameter N = 32,
    parameter d_max = 10
)(
    input signed [N-1:0] data_in,
    input [1:0] control,// 2'b00 = working; 2'b01 = stall; 2'b10 = init; 2'b11 = clear
    input [N-1:0] d_order_in,
    input clk,
    output logic signed [N-1:0] initial_inte[0:d_max-1],
    output logic init_inte,
    output logic [N-1:0] data_out
);

    logic signed [N-1:0] n_diff [0:d_max-1];
    logic signed [N-1:0] sum;
    logic [N-1:0] cnt;
    
    assign data_out = n_diff[d_order_in];
    assign initial_inte = n_diff;

    always_ff @ (posedge clk) begin
        case(control)
            2'b00: begin
                n_diff[0] <= data_in;
                for (int i = 1; i<d_max ;i++) begin
                    sum = 0;
                    for(int j = 0; j<i;j++) begin
                        sum += n_diff[j];
                    end
                    n_diff[i] <= data_in - sum;
                end
                if(cnt==d_order_in-1) begin
                    init_inte <= 1'b1;
                end
                else begin
                    init_inte <= 1'b0;
                end
                cnt <= cnt + 1;
            end
            2'b01: begin // stall mode
                
            end
            2'b10: begin // initialize mode
                
            end
            2'b11: begin // reset all registers
                sum<=0;
                cnt<=0;
                for (int i = 0; i<10 ;i++ ) begin
                    n_diff[i] <= 0;
                end
            end
        endcase
    end
    
            
    
    
endmodule

