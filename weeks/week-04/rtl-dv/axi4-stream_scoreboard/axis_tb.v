`timescale 1ns/1ps
`define TDATA_W 32
`define TKEEP_W 4
`define TID_W 8
`define TDEST_W 4
`define TXN_W 64
`define SB_DEPTH 1024

module axis_tb;

reg clk,rst_n;
//Slave 
reg [`TDATA_W-1:0] s_tdata;
reg [`TKEEP_W-1:0] s_tkeep;
reg [`TID_W-1:0] s_tid;
reg s_tlast;
reg s_tvalid;
wire s_tready;
//Master
wire [`TDATA_W-1:0] m_tdata;
wire [`TKEEP_W-1:0] m_tkeep;
wire [`TID_W-1:0] m_tid;
wire m_tlast;
wire m_tvalid;
reg m_tready;

axis dut (
    .clk(clk),
    .rst_n(rst_n),

    .s_tdata  (s_tdata),
    .s_tkeep  (s_tkeep),
    .s_tid    (s_tid),
    .s_tlast  (s_tlast),
    .s_tvalid (s_tvalid),
    .s_tready (s_tready),

    .m_tdata  (m_tdata),
    .m_tkeep  (m_tkeep),
    .m_tid    (m_tid),
    .m_tlast  (m_tlast),
    .m_tvalid (m_tvalid),
    .m_tready (m_tready)
);

initial clk=0;
always #5 clk= ~clk;

reg [`TXN_W-1:0] exp_q [0:`SB_DEPTH-1]; 
reg [`TXN_W-1:0] act_q [0:`SB_DEPTH-1]; 
integer          exp_head, exp_tail;    
integer          act_head, act_tail;    

initial begin
	exp_head=0;
	exp_tail=0;
	act_head=0;
	act_tail=0;
end

integer cycle_count,cou;
initial cycle_count=0;
always @(posedge clk) cycle_count=cycle_count+1;

reg [31:0] sent_cycle[0:`SB_DEPTH-1];
reg [31:0] recv_cycle[0:`SB_DEPTH-1];
integer sb_pass, lat_cyc, sb_fail,sb_total;
initial begin
	sb_pass=0;
	sb_fail=0;
	lat_cyc=0;
	sb_total=0;
end

always @(posedge clk) begin
	if (rst_n && s_tvalid && s_tready) begin
		exp_q[exp_tail]<={s_tdata, s_tkeep, s_tid, 4'b0, s_tlast, 15'b0}; //use the same destination so tdest is always 0
		sent_cycle[exp_tail]<=cycle_count;
		exp_tail<=exp_tail+1;
	end
end

always @(posedge clk) begin
        if (rst_n && m_tvalid && m_tready) begin
                act_q[act_tail]<={m_tdata, m_tkeep, m_tid, 4'b0, m_tlast, 15'b0};          
                recv_cycle[act_tail]<=cycle_count;
                act_tail<=act_tail+1;
        end
end

always @(posedge clk) begin
	if (rst_n && (act_tail>act_head) &&(exp_tail>exp_head)) begin
		sb_total=sb_total+1;
		if (act_q[act_head]===exp_q[exp_head]) begin
			sb_pass=sb_pass+1;
			lat_cyc=recv_cycle[act_head]-sent_cycle[exp_head];
		end else begin
			sb_fail=sb_fail+1;
			$display("DIFF: XOR mask=%h",act_q[act_head]^exp_q[exp_head]);
		end
		exp_head=exp_head+1;
		act_head=act_head+1;
	end
end

localparam BP_PROB=30;
reg bp_enable, force_low;
initial bp_enable=0;
initial force_low=0;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		m_tready<=1'b1;
	else if (force_low) 
		m_tready<=1'b0;
	else if (bp_enable)
		m_tready <= ($urandom_range(0,99)) >=BP_PROB;
	else m_tready<=1'b1;
end

localparam MAX_STALL=1000;
integer stall_counter,last_act_tail;

initial begin
	stall_counter=0;
	last_act_tail=0;
end

always @(posedge clk) begin
	if (act_tail==last_act_tail && exp_tail>exp_head)
		stall_counter=stall_counter+1;
	else begin
		stall_counter=0;
		last_act_tail=act_tail;
	end
	if (stall_counter>=MAX_STALL) begin
		$display("DEADLOCK detected");
		$finish;
	end
end

task apply_reset;
    begin
        rst_n    = 1'b0;
        s_tvalid = 1'b0;
        s_tdata  = 0;
        s_tkeep  = 0;
        s_tid    = 0;
        s_tlast  = 0;
	bp_enable= 0;
        m_tready = 1'b1;
        repeat(4) @(posedge clk);
        rst_n = 1'b1;
        @(posedge clk);
    end
endtask

task print_summary;
    input [63:0] test_id;
    begin
        $display("--------------------------------------------");
        $display("Test %0d complete  pass=%0d  fail=%0d  total=%0d",
                 test_id, sb_pass-cou, sb_fail, sb_total-cou);
        $display("--------------------------------------------");
    end
endtask

task send_beat;
	input [`TDATA_W-1:0] data;
	input [`TKEEP_W-1:0] keep;
	input [`TID_W-1:0] id;
	input last;
	begin
		@(posedge clk);
		s_tdata=data;
		s_tkeep=keep;
		s_tid=id;
		s_tlast=last;
		s_tvalid=1'b1;
		//wait for s_tready and s_tready
		while (!s_tready) @(posedge clk);
		#1;
		s_tvalid=1'b0;
	end
endtask

task send_packet;
	input integer n_beats;
	input [`TID_W-1:0] id;
	integer i;
	begin
		for (i=0; i<n_beats; i=i+1) begin
			send_beat($random, 4'b1111, id, (i==n_beats-1));
		end
	end
endtask

initial begin
	$dumpfile("tb_output.vcd");
	$dumpvars(0,dut);
	rst_n=0;
	apply_reset;
	cou=0;
	$display("reset check");
	@(posedge clk); #1;
	if (m_tvalid!=1'b0) $display("[FAIL] reset fail");
	else $display("[PASS] reset success");
	
	//send input and process output
	$display("single beat sending check");
	send_beat(32'h906, 4'b1111, 8'hAF, 1'b1);
	repeat(6) @(posedge clk);
	#1;
	if (sb_fail==0 && sb_total==1) $display("[PASS] single beat sent successfully, lat=%0d cycle", lat_cyc);
	else $display("[FAIL] single beat sent fail");
	cou=sb_total;

	//send 8 8-bit packets
	$display("8-bit sending check");
	apply_reset;
   	send_packet(8, 8'h01);
    	repeat(6) @(posedge clk);
    	if (sb_fail == 0 && sb_total == cou+8)
        	$display("[PASS] 8-bit beats sending successfully");
    	else
        	$display("[FAIL] 8-bit sending fail: pass=%0d fail=%0d total=%0d", sb_pass-cou, sb_fail-cou, sb_total-cou);
	cou=sb_total;

	//sending with back pressure
	$display("back-pressure check");
	apply_reset;
	@(posedge clk); #1;
	s_tdata=32'hF00D;
	s_tkeep=4'hF;
	s_tid=8'h69;
	s_tlast=1'b1;
	s_tvalid=1'b1;
	force_low=1'b1; //hold back-pressure for checking
	repeat(5) @(posedge clk);
	//data should be held
	if (m_tvalid == 1'b1 && m_tdata==32'hF00D) 
		$display("[PASS] back-pressure successful");
	else $display("[FAIL] back-pressure fail");
	force_low=1'b0;
	@(posedge clk);
	#1;
	s_tvalid=1'b0;
	repeat(4) @(posedge clk);
	cou=sb_total;

	//idle bundle
	$display("idle-bundle checking");
	apply_reset;
	send_beat(32'hABAB, 4'hF, 8'h5, 1'b0);
	repeat(5) @(posedge clk);
	if (m_tvalid!=1'b0)
		$display("[FAIL] m_tvalid did not deassert");
	else 
		$display("[PASS] m_tvalid deasserted correctly");
	send_beat(32'hDADA, 4'hF, 8'h22, 1'b1);
	repeat(4) @(posedge clk);
	cou=sb_total;

	//100 random tests with no back-pressure
	$display("100 random beats, no back-pressure");
	apply_reset;
	begin: ran1_block //create a name to declare new vars inside this block
		integer j;
		reg [`TDATA_W-1:0] rdata;
        	reg [`TKEEP_W-1:0] rkeep;
        	reg [`TID_W-1:0] rid;
        	reg rlast;
		for (j=0; j<100; j=j+1) begin
			rdata=$random;
			case ($urandom_range(0,3))
				0: rkeep=4'b0001;
				1: rkeep=4'b0011;
				2: rkeep=4'b0111;
				3: rkeep=4'b1111;
			endcase
			rid=$random%256;
			rlast=(j%8==7) ? 1'b1: ($urandom_range(0,3)==0);
			send_beat(rdata, rkeep, rid, rlast);
		end
	end
	repeat(8) @(posedge clk);
	print_summary(1);
	cou=sb_total;
	
	//200 random tests with back-pressure
	$display("200 random beats, back-pressure enabled");
	apply_reset;
	bp_enable=1;
	begin: ran2_block //create a name to declare new vars inside this block
		integer j;
		reg [`TDATA_W-1:0] rdata;
        	reg [`TKEEP_W-1:0] rkeep;
        	reg [`TID_W-1:0] rid;
        	reg rlast;
		for (j=0; j<200; j=j+1) begin
			rdata=$random;
			case ($urandom_range(0,3))
				0: rkeep=4'b0001;
				1: rkeep=4'b0011;
				2: rkeep=4'b0111;
				3: rkeep=4'b1111;
			endcase
			rid=$random%32;
			rlast=($urandom_range(0,3)==0);
			send_beat(rdata, rkeep, rid, rlast);
		end
	end
	repeat(16) @(posedge clk);
	print_summary(2);
	cou=sb_total;

	//10 variable-length packets sendings
	$display("10 variable-length packets (1-16 beats)");
    	apply_reset;
    	bp_enable = 1;
    	begin : r3_block
        	integer pkt, len;
        	for (pkt = 0; pkt < 10; pkt = pkt + 1) begin
            		len = ($urandom_range(0,15)) + 1;
            		$display("  packet %0d: %0d beats", pkt, len);
            		send_packet(len, pkt[7:0]);
            		s_tvalid = 0;
            		repeat($urandom_range(0,4)) @(posedge clk);
        	end
    	end
    	bp_enable = 0;
    	m_tready  = 1'b1;
    	repeat(16) @(posedge clk);
    	print_summary(3);
	cou=sb_total;

	//random stress - valid and ready
	$display("random valid and random ready");
	apply_reset;
    	bp_enable = 1;
    	begin : cr4_block
        	integer i;
        	integer sent;
        	sent = 0;
        	while (sent <= 500) begin
            		@(posedge clk); #1;
            		// Random valid: present data ~70 % of cycles
            		if ($urandom_range(0,99) < 70) begin
                	s_tdata  = $random;
                	s_tkeep  = 4'hF;
                	s_tid    = $random % 8;
                	s_tlast  = ($urandom_range(0,15) == 0);
                	s_tvalid = 1'b1;
                	if (s_tready)
                    		sent = sent + 1;   // count only accepted beats
            		end else begin
                		s_tvalid = 1'b0;
            		end
        	end
        	s_tvalid = 1'b0;
    	end
    	bp_enable = 0;
    	m_tready  = 1'b1;
    	repeat(16) @(posedge clk);
    	print_summary(4);

	$display("===================================");
    	$display("  OVERALL RESULT");
    	$display("  PASS: %0d  FAIL: %0d  TOTAL: %0d", sb_pass, sb_fail, sb_total);
    	if (sb_fail == 0)
        	$display("  *** ALL TESTS PASSED ***");
    	else
        	$display("  *** %0d FAILURES DETECTED ***", sb_fail);
    	$display("===================================");
    	$finish;
end
endmodule