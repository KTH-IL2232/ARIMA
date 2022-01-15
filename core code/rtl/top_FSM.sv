module top_fsm #(
    parameter N = 32
)(
    input [N-1:0] p_order,
    input [N-1:0] d_order,
    input [N-1:0] q_order,
    input start,
    input reset,
    input clk,

    output logic [1:0] c_diff,
    output logic [1:0] c_ar,
    output logic [1:0] c_ma,
    output logic [1:0] c_inte,
    output logic sel_inte_in,
    output logic ready,
    output logic [N-1:0] address_r,
    output logic rden,
    output logic [N-1:0] address_w,
    output logic [N-1:0] current_time_step,
    output logic wren,
    output logic init_mode
);

    parameter reset_state=0,init_diff=1,init_inte=2,init_arma=3,pipeline_clear=4,ready_state=5,work_diff=6,work_arma=7,work_inte=8;
    logic [3:0] state,next_state;
    logic [31:0] cnt;
    logic init_state_finish;
    logic switch_data_freq;
    
    reg [N-1:0] addr;

    assign current_time_step = addr-2;
    assign address_r = addr;
    assign address_w = addr + 1000;

    always_ff @( posedge clk ) begin : state_transition
        if (reset) begin
            state <= reset_state;
        end
        else begin
            state <= next_state;
        end
    end
    
    always_comb begin : next_state_logic
        case(state) 
            reset:begin
                next_state = start?init_diff:reset;
            end
            init_diff:begin
                next_state = init_state_finish?init_inte:init_diff;
            end
            init_inte:begin
                next_state = init_state_finish?init_arma:init_inte;
            end
            init_arma:begin
                next_state = init_state_finish?pipeline_clear:init_arma;
            end
            pipeline_clear:begin
                next_state = (cnt==1)?ready_state:pipeline_clear;
            end
            ready_state:begin
                next_state = work_diff;
            end
            work_diff:begin
                next_state = work_arma;
            end
            work_arma:begin
                next_state = work_inte;
            end
            work_inte:begin
                next_state = ready_state;
            end
        endcase
    end

    always_ff @( posedge clk ) begin : state_cnt
        case(state) 
            reset:begin
                cnt <= 0;
            end
            init_diff:begin
                if (cnt==d_order-1) begin
                    cnt <= 0;
                end
                else if(d_order==0) begin
                    cnt <= 0;
                end
                else begin
                    cnt <= cnt + 1;
                end
            end
            init_inte:begin
                cnt <= 0;
            end
            init_arma:begin
                if (cnt==p_order-1) begin
                    cnt <= 0;
                end
                else begin
                    cnt <= cnt + 1;
                end
            end
            pipeline_clear:begin
                if (cnt==1) begin
                    cnt <= 0;
                end
                else begin
                    cnt <= cnt+1;
                end
            end
            ready_state:begin
                cnt <= 0;
            end
            work_diff:begin
                cnt <= 0;
            end
            work_arma:begin
                cnt <= 0;
            end
            work_inte:begin
                cnt <= 0;
            end
        endcase
    end

    always_comb begin : init_state_f
        case(state)
        reset:init_state_finish=1'b0;
        init_diff:begin
            if(d_order==0) begin
                init_state_finish=1'b1;
            end
            else begin
                if(cnt==d_order-1) begin
                    init_state_finish=1'b1;
                end
            end
        end
        init_inte:begin
            init_state_finish=1'b1;
        end
        init_arma:begin
            if(p_order==0) begin
                init_state_finish=1'b1;
            end
            else begin
                if(cnt==p_order-1) begin
                    init_state_finish=1'b1;
                end
                else
                    init_state_finish=1'b0;
            end
                
        end
        pipeline_clear:init_state_finish=1'b0;
        ready_state:begin 
            init_state_finish=1'b0;
        end
        work_diff:init_state_finish=1'b0;
        work_arma:init_state_finish=1'b0;
        work_inte:init_state_finish=1'b0;
        endcase
    end

    always_ff @( posedge clk ) begin : output_logic
        case(state) 
            reset:begin
                c_diff <= 2'b11;
                c_ar <= 2'b11;
                c_ma <= 2'b11;
                c_inte <= 2'b11;
                ready <= 1'b0;
                sel_inte_in <= 1'b1;
                addr <= 0;
                rden <= 1'b1;
                wren <= 1'b0;
                init_mode <= 1'b1;
            end
            init_diff:begin
                c_diff <= 2'b00;
                c_ar <= 2'b11;
                c_ma <= 2'b11;
                c_inte <= 2'b11;
                ready <= 1'b0;
                addr <= addr+1;
                rden <= 1'b1;
                wren <= 1'b0;
            end
            init_inte:begin
                c_diff <= 2'b00;
                c_ar <= 2'b11;
                c_ma <= 2'b11;
                c_inte <= 2'b10;
                ready <= 1'b0;
                addr <= addr+1;
                rden <= 1'b1;
                wren <= 1'b0;
            end
            init_arma:begin
                c_diff <= 2'b00;
                c_ar <= 2'b00;
                c_ma <= 2'b11;
                c_inte <= 2'b00;
                ready <= 1'b0;
                addr <= addr+1;
                rden <= 1'b1;
                wren <= 1'b1;
            end
            pipeline_clear:begin
                if(cnt==0) begin
                    c_diff <= 2'b01;
                    c_ar <= 2'b00;
                    c_ma <= 2'b00;
                    c_inte <= 2'b00;
                    ready <= 1'b1;
                    // address_r <= address_r+1;
                    rden <= 1'b1;
                    wren <= 1'b1;
                end
                if(cnt==1) begin
                    c_diff <= 2'b01;
                    c_ar <= 2'b01;
                    c_ma <= 2'b01;
                    c_inte <= 2'b00;
                    ready <= 1'b1;
                    rden <= 1'b0;
                    wren <= 1'b1;
                end
            end
            ready_state:begin
                c_diff <= 2'b01;
                c_ar <= 2'b01;
                c_ma <= 2'b01;
                c_inte <= 2'b01;
                ready <= 1'b1;
                sel_inte_in = 1'b0;
                rden <= 1'b0;
                wren <= 1'b0;
                init_mode <= 1'b0;
                addr <= addr+1;
            end
            work_diff:begin
                c_diff <= 2'b00;
                c_ar <= 2'b01;
                c_ma <= 2'b01;
                c_inte <= 2'b01;
                ready <= 1'b0;
                rden <= 1'b1;
                wren <= 1'b0;
            end
            work_arma:begin
                c_diff <= 2'b01;
                c_ar <= 2'b00;
                c_ma <= 2'b00;
                c_inte <= 2'b01;
                ready <= 1'b0;
                rden <= 1'b0;
                wren <= 1'b1;
            end
            work_inte:begin
                c_diff <= 2'b01;
                c_ar <= 2'b01;
                c_ma <= 2'b01;
                c_inte <= 2'b00;
                ready <= 1'b0;
                rden <= 1'b0;
                wren <= 1'b0;
            end
        endcase
    end

endmodule