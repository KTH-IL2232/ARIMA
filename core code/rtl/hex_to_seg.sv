module hex_to_seg (
    input [7:0] hex,
    input clk,
    output logic [7:0] seg
);

    logic [6:0] seg1;
    logic [6:0] seg2;
    
    always_comb begin : segment1
        case(hex[3:0])
            4'b0000: seg1 = 7'b0111111;
            4'b0001: seg1 = 7'b0000110;
            4'b0010: seg1 = 7'b1011011;
            4'b0011: seg1 = 7'b1001111;
            4'b0100: seg1 = 7'b1100110; 
            4'b0101: seg1 = 7'b1101101;
            4'b0110: seg1 = 7'b1111101;
            4'b0111: seg1 = 7'b0000111;
            4'b1000: seg1 = 7'b1111111;
            4'b1001: seg1 = 7'b1101111; 
            4'b1010: seg1 = 7'b1110111; 
            4'b1011: seg1 = 7'b1111100;
            4'b1100: seg1 = 7'b0111001;
            4'b1101: seg1 = 7'b1011110;
            4'b1110: seg1 = 7'b1111001;
            4'b1111: seg1 = 7'b1110001;
        endcase
    end

    always_comb begin : segment2
        case(hex[7:4])
            4'b0000: seg2 = 7'b0111111;
            4'b0001: seg2 = 7'b0000110;
            4'b0010: seg2 = 7'b1011011;
            4'b0011: seg2 = 7'b1001111;
            4'b0100: seg2 = 7'b1100110; 
            4'b0101: seg2 = 7'b1101101;
            4'b0110: seg2 = 7'b1111101;
            4'b0111: seg2 = 7'b0000111;
            4'b1000: seg2 = 7'b1111111;
            4'b1001: seg2 = 7'b1101111; 
            4'b1010: seg2 = 7'b1110111; 
            4'b1011: seg2 = 7'b1111100;
            4'b1100: seg2 = 7'b0111001;
            4'b1101: seg2 = 7'b1011110;
            4'b1110: seg2 = 7'b1111001;
            4'b1111: seg2 = 7'b1110001;
        endcase
    end

    assign seg = clk?{1'b0,seg1}:{1'b1,seg2};

endmodule