module qmult #(
	//Parameterized values
	parameter Q = 15,
	parameter N = 32
	)
	(
	 input			[N-1:0]	i_multiplicand,
	 input			[N-1:0]	i_multiplier,
	 output			[N-1:0]	o_result,
	 output	reg				ovr
	 );
	 
	 //	The underlying assumption, here, is that both fixed-point values are of the same length (N,Q)
	 //		Because of this, the results will be of length N+N = 2N bits....
	 //		This also simplifies the hand-back of results, as the binimal point 
	 //		will always be in the same location...



	reg [2*N-1:0]	r_result;		//	Multiplication by 2 values of N bits requires a 
											//		register that is N+N = 2N deep...
	reg [N-1:0]		r_RetVal;
	reg [N-1:0]     multiplicand;
    reg [N-1:0]     multiplier;
//--------------------------------------------------------------------------------
	assign multiplicand = tscom(i_multiplicand);
    assign multiplier = tscom(i_multiplier);
	assign o_result = tscom(r_RetVal);	//	Only handing back the same number of bits as we received...
											//		with fixed point in same location...
	
//---------------------------------------------------------------------------------
	always @(multiplicand, multiplier)	begin						//	Do the multiply any time the inputs change
		r_result <= multiplicand[N-2:0] * multiplier[N-2:0];	//	Removing the sign bits from the multiply - that 
																					//		would introduce *big* errors	
		ovr <= 1'b0;															//	reset overflow flag to zero
		end
	
		//	This always block will throw a warning, as it uses a & b, but only acts on changes in result...
	always @(r_result) begin													//	Any time the result changes, we need to recompute the sign bit,
		r_RetVal[N-1] <= multiplicand[N-1] ^ multiplier[N-1];	//		which is the XOR of the input sign bits...  (you do the truth table...)
		r_RetVal[N-2:0] <= r_result[N-2+Q:Q];								//	And we also need to push the proper N bits of result up to 
																						//		the calling entity...
		if (r_result[2*N-2:N-1+Q] > 0)										// And finally, we need to check for an overflow
			ovr <= 1'b1;
		end

    function [N-1:0] tscom;
        input [N-1:0] data;
        begin
            tscom[N-1] = data[N-1];
            if (data[N-1]==1'b1)
            tscom[N-2:0] = ~data[N-2:0] + 1;
            else
            tscom[N-2:0] = data[N-2:0];
        end
        
    endfunction

endmodule