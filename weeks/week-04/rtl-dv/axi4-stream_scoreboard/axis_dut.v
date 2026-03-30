module axis #(
  parameter int DATA_W = 32,
  parameter int KEEP_W = DATA_W / 8
)(
	input clk, rst_n,
	
	// Slave port
	input [DATA_W-1:0] s_tdata,
	input [KEEP_W-1:0] s_tkeep,
	input [7:0] s_tid,
	input s_tlast,
	input s_tvalid,
	output s_tready,

	// Master port
	output reg [DATA_W-1:0] m_tdata,
	output reg m_tvalid,
	output reg [KEEP_W-1:0] m_tkeep,
	output reg [7:0] m_tid,
	output reg m_tlast,
	input m_tready
);
assign s_tready=!m_tvalid||m_tready;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		m_tvalid<=1'b0;
		m_tdata<='0;
		m_tkeep<='0;
		m_tid<='0;
		m_tlast<=1'b0;
	end else begin
		if (s_tready) begin
			if (s_tvalid) begin
				m_tdata<=s_tdata;
				m_tkeep<=s_tkeep;
				m_tid<=s_tid;
				m_tvalid<=1'b1;
				m_tlast<=s_tlast;
			end else begin
				m_tvalid<=1'b0;
			end
		end 
	end
end
endmodule