module control_unit (
    input signed [31:0] data_in,
    input [31:0] p_order_in,
    input [31:0] d_order_in,
    input [31:0] q_order_in,
    input signed [31:0] ar_coef_in [0:9],
    input signed [31:0] ma_coef_in [0:9],
    input signed [31:0] cont_in,
    input start,
    input rst,
    input clk,

    output logic [1:0] c_diff,
    output logic [1:0] c_ar,
    output logic [1:0] c_ma,
    output logic [1:0] c_inte,
    output logic sel_inte_in,

    output logic [31:0]  p_order,
    output logic [31:0]  d_order,
    output logic [31:0]  q_order,
    output logic signed [31:0]  ar_coef [0:9],
    output logic signed [31:0]  ma_coef [0:9],
    output logic signed [31:0]  cont
);
// initial data order: p_order,d_order,q_order,ar_coef,ma_coef,data_in

    logic [31:0] init;
    parameter reset=0,init_p1=1,init_p2=2,init_p3=3,normal_work=4,init_p1_1=5;
    logic [2:0] state,next_state;
    logic [31:0] cnt;

always_comb begin
    p_order = p_order_in;
    d_order = d_order_in;
    q_order = q_order_in;
    ar_coef = ar_coef_in;
    ma_coef = ma_coef_in;
    cont = cont_in;
end

always@(*) begin //next_state transition logic
    case(state)
        reset:begin 
            next_state=start?init_p1:reset;
            c_diff = 2'b11;
            c_ar = 2'b11;
            c_ma = 2'b11;
            c_inte = 2'b11;
            sel_inte_in = 1'b1;
        end
        init_p1:begin
            next_state=init_p1_1;
            c_diff = 2'b00;
            c_ar = 2'b01;
            c_ma = 2'b01;
            c_inte = 2'b10;
        end
        init_p1_1:begin
            next_state=init_p2;
            c_diff = 2'b00;
            c_ar = 2'b01;
            c_ma = 2'b01;
            c_inte = 2'b00;
        end
        init_p2:begin
            if(cnt==p_order_in) begin
                next_state=init_p3;
            end
            else begin
                next_state=init_p2;
            end
            c_diff = 2'b00;
            c_ar = 2'b10;
            c_ma = 2'b10;
            c_inte = 2'b00;
        end
        init_p3:begin
            if(cnt==0) begin
                next_state=normal_work;
            end
            c_diff = 2'b00;
            c_ar = 2'b00;
            c_ma = 2'b10;
            c_inte = 2'b00;
        end
        normal_work:begin
            next_state=normal_work;
            sel_inte_in = 1'b0;
            c_diff = 2'b00;
            c_ar = 2'b00;
            c_ma = 2'b00;
            c_inte = 2'b00;
        end
    endcase
end
//state transition logic
always@(posedge clk) begin
    if (rst) begin
        state<=reset;
        cnt<=0;
    end

    else
        state<=next_state;
end
// assign start_shifting=(state==s4);
// output by register
always@(posedge clk) begin
    case(state)
        reset:begin

        end
        init_p1:begin
            if (cnt!=d_order_in-1) begin
                cnt <= cnt + 1;
            end
            else begin
                cnt <= 0;
            end

        end
        init_p2:begin
            if (cnt!=p_order_in) begin
                cnt <= cnt + 1;
            end
            else begin
                cnt <= 0;
            end
        end
        init_p3:begin
            if (cnt!=0) begin
                cnt <= cnt + 1;
            end
            else begin
                cnt <= 0;
            end
        end
        normal_work:begin

        end
    endcase
end


endmodule
