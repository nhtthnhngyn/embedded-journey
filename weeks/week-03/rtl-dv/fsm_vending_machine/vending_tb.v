`timescale 1ns/1ps
module vending_tb;

reg clk,rst_n;
reg [9:0] mo_lef;
reg add_mon;
reg [9:0] mon_add;
reg tak_bac;
reg pay_card;
reg pro_chose, add, back, timer;
reg [4:0] pro_detail;
reg check_out, conf;

wire [9:0] mo_out;
wire [9:0] mo_left;
wire [9:0] shortfall;
wire [4:0] displaying;
wire [4:0] pro_out[0:10];
wire [4:0] cart[0:10];
wire [4:0] pro_count;
wire trans_done, error, cart_full;

integer watchdog;
initial watchdog=0;

integer state_hit[0:3];
integer i;
initial begin
    for(i=0;i<4;i=i+1)
        state_hit[i] = 0;
end

vending_machine dut (
    .clk(clk),         .rst_n(rst_n),
    .mo_lef(mo_lef),                     
    .add_mon(add_mon), .mon_add(mon_add),
    .tak_bac(tak_bac), .pay_card(pay_card),
    .pro_chose(pro_chose), .pro_detail(pro_detail),
    .add(add),         .back(back),
    .timer(timer),     .check_out(check_out),
    .conf(conf),
    .mo_out(mo_out),
    .mo_left(mo_left),
    .shortfall(shortfall),
    .displaying(displaying),
    .pro_out(pro_out),
    .cart(cart),
    .pro_count(pro_count),
    .trans_done(trans_done),
    .error(error),
    .cart_full(cart_full)
);

always @(posedge clk) begin
    state_hit[dut.state] = state_hit[dut.state] + 1;
end

initial clk=0;
always #5 clk=~clk; //100MHz clock

integer pass_cnt; initial pass_cnt=0;
integer fail_cnt; initial fail_cnt=0;

task check1;
	input got;
	input expected;
	input[255:0] label;
begin
	if (got===expected) begin
	 $display("[Pass] %0s",label);
	 pass_cnt=pass_cnt+1;
	end else begin
	 $display("[FAIL] %0s expected=%0b got=%0b @%0t ns", label, expected, got, $time);
	 fail_cnt=fail_cnt+1;
	end
end
endtask

task check10;
	input[9:0] got;
	input[9:0] expected;
	input[255:0] label;
begin 
	if (got===expected) begin
	 $display("[Pass] %0s",label);
	 pass_cnt=pass_cnt+1;
	end else begin
	 $display("[FAIL] %0s expected=%0d got=%0d @%0t ns", label, expected, got, $time);
	 fail_cnt=fail_cnt+1;
	end
end
endtask

task check5;
	input[4:0] got;
	input[4:0] expected;
	input[255:0] label;
begin 
	if (got===expected) begin
	 $display("[Pass] %0s",label);
	 pass_cnt=pass_cnt+1;
	end else begin
	 $display("[FAIL] %0s expected=%0d got=%0d @%0t ns", label, expected, got, $time);
	 fail_cnt=fail_cnt+1;
	end
end
endtask

task do_reset;
begin
	watchdog=0;
	rst_n=0;
	repeat(8) @(posedge clk);
	rst_n=1;
	repeat(2) @(posedge clk);
end
endtask

task clear_inputs;
begin
    mo_lef=0; add_mon=0; mon_add=0; tak_bac=0; pay_card=0;
    pro_chose=0; pro_detail=0; add=0; back=0; timer=0;
    check_out=0; conf=0;
end
endtask

reg [9:0] tb_price [0:31];
initial begin
    tb_price[0]=85;  tb_price[1]=125; tb_price[2]=125; tb_price[3]=150;
    tb_price[4]=110; tb_price[5]=110; tb_price[6]=200; tb_price[7]=175;
    tb_price[8]=75;  tb_price[9]=75;  tb_price[10]=75; tb_price[11]=90;
    tb_price[12]=90; tb_price[13]=65; tb_price[14]=65; tb_price[15]=80;
    tb_price[16]=80; tb_price[17]=60; tb_price[18]=100;tb_price[19]=225;
    tb_price[20]=175;tb_price[21]=250;tb_price[22]=200;tb_price[23]=150;
    tb_price[24]=120;tb_price[25]=115;tb_price[26]=100;tb_price[27]=130;
    tb_price[28]=150;tb_price[29]=125;tb_price[30]=200;tb_price[31]=175;
end

always @(posedge clk) begin
	watchdog=watchdog+1;
	if (watchdog > 500000) begin
	 $display("[FATAL] Watchdog triggered — DUT stuck at %0t ns", $time);
	 $display("        FAILED: %0d  PASSED: %0d", fail_cnt, pass_cnt);
	 $finish;
	end
end

task press_browse;   begin pro_chose=1;  @(posedge clk); #1 pro_chose=0;  end endtask
task press_add;      begin add=1;        @(posedge clk); #1 add=0;        end endtask
task press_checkout; begin check_out=1;  @(posedge clk); #1 check_out=0;  end endtask
task press_back;     begin back=1;       @(posedge clk); #1 back=0;       end endtask
task press_takbac;   begin tak_bac=1;    @(posedge clk); #1 tak_bac=0;    end endtask
task press_timer;    begin timer=1;      @(posedge clk); #1 timer=0;      end endtask

task browse_and_add;
input [4:0] prod;
begin
    pro_detail = prod;
    press_browse;
    repeat(2) @(posedge clk);   // wait for state transition AND balance load
    #2;
    press_add;
    @(posedge clk);             
end
endtask

reg [9:0] sampled_mo_left;
reg [9:0] sampled_shortfall;
reg       sampled_trans_done;
reg       sampled_error;
reg [4:0] sampled_pro_out [0:10];
task confirm_and_sample;
	integer k;
begin
	conf=1;
	@(posedge clk);
	#2;
	sampled_mo_left=mo_left;
	sampled_shortfall=shortfall;
	for(k=0;k<11;k=k+1)
	 sampled_pro_out[k]=pro_out[k];
	#1 conf=0;
	@(posedge clk);
	#2;
	sampled_trans_done=trans_done;
	sampled_error=error;
	@(posedge clk);
end
endtask

reg[9:0] sampled_mo_out;

task press_takbac_and_sample;
begin
        #2;
	tak_bac=1;
	@(posedge clk);
	#2;
	sampled_mo_out=mo_out;
	#1 tak_bac=0;
	@(posedge clk);
end
endtask

task test_normal_purchase;
begin
    $display("\n=== Happy Path: Cola $1.25, pay $2.00 ===");
    do_reset; clear_inputs;

    mo_lef = 10'd200;           
    browse_and_add(5'd1);       
    press_checkout; @(posedge clk);
    confirm_and_sample;

    check1 (sampled_trans_done, 1, "trans_done=1");     
    check1 (sampled_error,0,"error=0");
    check10(sampled_mo_left,    10'd75, "change = 200-125 = 75");
end
endtask

task test_insufficient_funds;
begin
    $display("\n=== Error Path: Noodle Cup $2.50, pay $1.00 ===");
    do_reset; clear_inputs;

    mo_lef = 10'd100;           
    browse_and_add(5'd21);      
    press_checkout; @(posedge clk);
    confirm_and_sample;

    check1 (sampled_error,1,"error=1");     
    check1 (sampled_trans_done, 0,"trans_done=0");
    check10(sampled_shortfall,  10'd150, "shortfall = 250-100 = 150");
end
endtask

task test_take_back_change;
begin
    $display("\n=== Change Return: Take back money ===");

    do_reset; 
    clear_inputs;

    // Insert $2.00
    mo_lef = 10'd200;

    // Buy Cola ($1.25)
    browse_and_add(5'd1);

    press_checkout; 
    @(posedge clk);

    confirm_and_sample;

    // Verify purchase succeeded
    check1(sampled_trans_done,1,"purchase success");
    check10(sampled_mo_left,10'd75,"change = 75");

    // Take back change
    press_takbac_and_sample;

    check10(sampled_mo_out,10'd75,"mo_out = returned change");

end
endtask

task test_givbac_exact_change;
begin
    $display("\n=== GIV_BAC: Exact change ===");

    do_reset;
    clear_inputs;

    mo_lef = 10'd125;

    browse_and_add(5'd1); // assume product 1 costs 125

    press_checkout;
    @(posedge clk);

    confirm_and_sample;

    check1(sampled_trans_done,1,"transaction success");
    check10(sampled_mo_left,10'd0,"no change expected");

    press_takbac_and_sample;

    check10(sampled_mo_out,10'd0,"mo_out = 0");

end
endtask

task test_givbac_large_change;
begin
    $display("\n=== GIV_BAC: Large change return ===");

    do_reset;
    clear_inputs;

    mo_lef = 10'd500;

    browse_and_add(5'd1); // price 125

    press_checkout;
    @(posedge clk);

    confirm_and_sample;

    check10(sampled_mo_left,10'd375,"large change correct");

    press_takbac_and_sample;

    check10(sampled_mo_out,10'd375,"large change returned");

end
endtask

task test_givbac_no_purchase;
begin
    $display("\n=== GIV_BAC: No purchase ===");

    do_reset;
    clear_inputs;

    mo_lef = 10'd200;

    press_takbac_and_sample;

    check10(sampled_mo_out,10'd200,"return full balance");

end
endtask

task test_givbac_multiple_products;
begin
    $display("\n=== GIV_BAC: Multiple products ===");

    do_reset;
    clear_inputs;

    mo_lef = 10'd400;

    browse_and_add(5'd1);
    browse_and_add(5'd1);

    press_checkout;
    @(posedge clk);

    confirm_and_sample;

    check1(sampled_trans_done,1,"transaction success");

    press_takbac_and_sample;

    check10(sampled_mo_out,sampled_mo_left,"returned correct remaining change");

end
endtask

task test_givbac_double_press;
begin
    $display("\n=== GIV_BAC: Double tak_bac press ===");

    do_reset;
    clear_inputs;

    mo_lef = 10'd200;

    press_takbac_and_sample;

    check10(sampled_mo_out,10'd200,"first return correct");

    press_takbac_and_sample;

    check10(sampled_mo_out,10'd0,"second return should be zero");

end
endtask

task test_exact_amount;
begin
    $display("\n=== Boundary: Exact amount (Gum $0.60, pay exactly $0.60) ===");
    do_reset; clear_inputs;

    mo_lef = 10'd60;            
    browse_and_add(5'd17);      

    press_checkout; @(posedge clk);
    confirm_and_sample;

    check1 (sampled_trans_done, 1,"trans_done=1 at exact price");
    check10(sampled_mo_left,    10'd0, "zero change");
    check1(sampled_error,0,"No error");
end
endtask

task test_timeout_cancels_browse;
begin
    $display("\n=== Transition: DIS_PRO → IDLE via timer ===");
    do_reset; clear_inputs;
    mo_lef = 10'd200; pro_detail = 5'd3;
    press_browse; repeat(2) @(posedge clk);
    check5(displaying, 5'd3, "displaying=3 in DIS_PRO");
    press_timer; repeat(2) @(posedge clk);
    check5(displaying, 5'd0, "displaying=0 after timer (back in IDLE)");
end
endtask

task test_add_in_idle;
begin
    $display("\n=== Adversarial: Press add while in IDLE — must be ignored ===");
    do_reset; clear_inputs;
    mo_lef = 10'd200;
    press_add;         
    repeat(2) @(posedge clk);
    check5(pro_count, 5'd0, "pro_count=0 (add ignored in IDLE)");
end
endtask

task test_conf_in_dispro;
begin
    $display("\n=== Adversarial: Press conf while in DIS_PRO — must be ignored ===");
    do_reset; clear_inputs;
    mo_lef = 10'd200; pro_detail = 5'd1;
    press_browse; repeat(2) @(posedge clk);
    conf = 1; @(posedge clk); #2;
    check1(trans_done, 0, "trans_done=0 (conf ignored in DIS_PRO)");
    #1 conf = 0;
end
endtask

task test_cart_overflow_guard;
begin
    integer k;
    $display("\n=== Adversarial: Add 12 items — cart max is 11 ===");
    do_reset; clear_inputs;
    mo_lef = 10'd1023;
    for (k = 0; k < 12; k = k + 1)
        browse_and_add(5'd17); 
    repeat(2) @(posedge clk);
    check5(pro_count, 5'd11, "pro_count capped at 11");
    check1(cart_full,  1, "cart is full, can not add more");
end
endtask

task test_topup_then_buy;
begin
$display("\n=== Multi-cycle: Top-up at checkout ===");
    do_reset; clear_inputs;

    mo_lef = 10'd100;           
    browse_and_add(5'd19);
    press_checkout; @(posedge clk);
    confirm_and_sample;

    check1(sampled_error, 1, "error=1 before top-up");
    // Top up $1.50 → balance = 100+150 = 250 >= 225
    #2;
    add_mon = 1; mon_add = 10'd150;
    @(posedge clk); #1 add_mon = 0;
    repeat(2) @(posedge clk);
    confirm_and_sample;
    check1 (sampled_trans_done, 1,"trans_done=1 after top-up");
    check10(sampled_mo_left,10'd25, "change = 250-225 = 25");
    check1 (sampled_error,0,"No error after topup");
end
endtask

task test_random;
   integer iter, seed, raw;
   integer num_items;
   reg[4:0] prod0, prod1, prod2, prod3;
   reg[9:0] rand_bal, expected_total;
begin
   $display("\n===Randomised Stress - 40 iters, 1-4 items each===");
   seed=143;

   for (iter=0; iter<40; iter=iter+1) begin
    do_reset; clear_inputs;
    raw=$random(seed); if (raw<0) raw=-raw;
    num_items=(raw%4)+1;
    
    expected_total=0;
    raw=$random(seed); if (raw<0) raw=-raw;
    prod0=raw[4:0]; expected_total=expected_total+tb_price[prod0];

    if (num_items >=2) begin
     raw=$random(seed); if (raw<0) raw=-raw;
     prod1=raw[4:0]; expected_total=expected_total+tb_price[prod1];
    end

    if (num_items >=3) begin
     raw=$random(seed); if (raw<0) raw=-raw;
     prod2=raw[4:0]; expected_total=expected_total+tb_price[prod2];
    end

    if (num_items >=4) begin
     raw=$random(seed); if (raw<0) raw=-raw;
     prod3=raw[4:0]; expected_total=expected_total+tb_price[prod3];
    end

    // Min 50: avoids trivially zero balance; max 1023: fits in 10 bits
    raw = $random(seed); if (raw<0) raw=-raw;
    rand_bal = (raw % 10'd974) + 10'd50;
    mo_lef   = rand_bal;

    $write("  [iter %0d] items=%0d bal=%0d total=%0d prods=[%0d",iter,num_items, rand_bal, expected_total, prod0);
    if (num_items>=2) $write(",%0d", prod1);
    if (num_items>=3) $write(",%0d", prod2);
    if (num_items==4) $write(",%0d", prod3);
    $display("]");

    browse_and_add(prod0);
    if (num_items >= 2) browse_and_add(prod1);
    if (num_items >= 3) browse_and_add(prod2);
    if (num_items == 4) browse_and_add(prod3);
    press_checkout; @(posedge clk);
    confirm_and_sample;

    if (rand_bal >= expected_total) begin
      check1 (sampled_trans_done, 1'b1, "random: trans_done=1");
      check1 (sampled_error,      1'b0, "random: error=0");
      check10(sampled_mo_left, rand_bal - expected_total,"random: correct change");
    end else begin
      check1 (sampled_error,      1'b1, "random: error=1 (insufficient)");
      check1 (sampled_trans_done, 1'b0, "random: trans_done=0");
    end
   end
end
endtask

initial begin
    $dumpfile("tb_output.vcd");
    $dumpvars(0, dut);
    rst_n = 0;
    clear_inputs;
    #2;
    press_takbac_and_sample;
    #2;
    test_normal_purchase;
    #2;
    test_insufficient_funds;
    #2;
    test_exact_amount;
    #2;
    test_take_back_change;
    #2;
    test_givbac_exact_change;
    #2;
    test_givbac_large_change;
    #2;
    test_givbac_no_purchase;
    #2;
    test_givbac_multiple_products;
    #2;
    test_givbac_double_press;
    #2;
    test_timeout_cancels_browse;
    #2;
    test_add_in_idle;
    #2;
    test_conf_in_dispro;
    #2;
    test_cart_overflow_guard;
    #2;
    test_topup_then_buy;
    #2;
    test_random;

    $display("State coverage:");
    $display("IDLE     %d", state_hit[0]);
    $display("DIS_PRO  %d", state_hit[1]);
    $display("PRO_CHEC %d", state_hit[2]);
    $display("GIV_BAC  %d", state_hit[3]);

    $display("\n╔══════════════════════════════╗");
    $display("║       TEST SUMMARY           ║");
    $display("║  PASSED : %-4d               ║", pass_cnt);
    $display("║  FAILED : %-4d               ║", fail_cnt);
    $display("╚══════════════════════════════╝");
    if (fail_cnt == 0)
     $display("ALL TESTS PASSED\n");
    else
     $display("SOME TESTS FAILED — check [FAIL] lines above\n");
$finish;   
end


endmodule