module adder_dut #(parameter num_width=8) (
input [2:0] oper,
input [num_width-1:0] num_a,
input [num_width-1:0] num_b,
input cin,
output reg cout,
output reg [num_width-1:0] ans,
output neg,
output zer,
output ovf );

//oper=0 -> NOT a
//oper=1 -> a+b
//oper=2 -> a-b
//oper=3 -> a AND b
//oper=4 -> a OR b
//oper=5 -> a XOR b
//oper=6 -> a shift right b positions
//oper=7 -> a shift left b positions

always @(*) begin
	cout=1'b0;
	ans='0;
	case (oper)
		3'd0: begin
			`ifdef BUG_WRONG_NUM
				ans=~num_b;
			`else ans = ~num_a;
			`endif
		end
		3'd1: begin
			`ifdef BUG_ADD_SUBTRACT
				{cout,ans}=num_a-num_b+cin;
			`elsif BUG_IGNORE_CIN
				{cout,ans} = num_a+num_b;
			`elsif BUG_TRUNCATE
				{cout,ans}= num_a[num_width-2:0]+num_b[num_width-2:0]+cin;
			`else {cout,ans}=num_a+num_b+cin;
			`endif
		end
		3'd2: begin
			`ifdef BUG_IGNORE_CIN
				ans=num_a-num_b;
			`elsif BUG_SWAP_PLACE
				ans=num_b-num_a;
			`else ans = num_a-num_b-cin;
			`endif
		end
		3'd3: begin
			`ifdef BUG_LOGICAL_AND
				ans=num_a&&num_b;
			`else ans = num_a & num_b;
			`endif
		end
		3'd4: begin
			`ifdef BUG_LOGICAL_OR
				ans=num_a||num_b;
			`else ans = num_a | num_b;
			`endif
		end
		3'd5: ans = num_a ^ num_b;
		3'd6: begin
			`ifdef BUG_WRONG_DIRECTION
				ans=num_a << num_b[$clog2(num_width)-1:0];
			`else ans = num_a >> num_b[$clog2(num_width)-1:0];
			`endif
		end
		3'd7: ans = num_a << num_b[$clog2(num_width)-1:0];
		default: begin
			cout=1'b0;
			ans={num_width{1'b0}};
		end
	endcase
end

assign neg = (ans[num_width-1]==1'b1);
assign zer = (ans == {num_width{1'b0}});
assign ovf = (oper==3'd1) ? cout : (oper==3'd2) ? (num_b > num_a) : 1'b0;
endmodule
