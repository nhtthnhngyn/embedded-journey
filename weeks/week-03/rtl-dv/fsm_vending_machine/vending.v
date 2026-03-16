module vending_machine (
	// ── Clock & Reset ──────────────────────────────────────────
    input  wire        clk,          // System clock
    input  wire        rst_n,        // Active-low asynchronous reset

    // ── Money ──────────────────────────────────────────────────
    input  wire [9:0]  mo_lef,       // Initial money loaded by user
    input  wire        add_mon,      // Pulse: request to add money
    input  wire [9:0]  mon_add,      // Amount to add when add_mon is high
    input  wire        tak_bac,      // Pulse: user wants money back
    input  wire        pay_card,     // High when card payment is approved

    // ── Product Selection ──────────────────────────────────────
    input  wire        pro_chose,    // Pulse: enter product browse mode
    input  wire [4:0]  pro_detail,   // Index of product being browsed (0-31)
    input  wire        add,          // Pulse: add browsed product to cart
    input  wire        back,         // Pulse: cancel / go back
    input  wire        timer,        // Pulse: inactivity timeout

    // ── Checkout ───────────────────────────────────────────────
    input  wire        check_out,    // Pulse: proceed to checkout
    input  wire        conf,         // Pulse: confirm and pay

    // ── Money Outputs ──────────────────────────────────────────
    output reg  [9:0]  mo_out,       // Change dispensed to user
    output reg  [9:0]  mo_left,      // Remaining balance after purchase
    output reg  [9:0]  shortfall,    // Amount of money required to complete purchasing

    // ── Display & Dispensing ───────────────────────────────────
    output reg  [4:0]  displaying,        // Product index on screen
    output reg  [4:0]  pro_out [0:10],    // Dispensed products list

    // ── Cart & Status ──────────────────────────────────────────
    output reg  [4:0]  cart     [0:10],   // Items currently in cart
    output reg  [4:0]  pro_count,         // Number of items in cart
    output reg         trans_done,        // High for one cycle when purchase completes
    output reg         error,              // High when payment is insufficient
    output reg         cart_full
);
	typedef enum logic [1:0] {
    		IDLE,
    		DIS_PRO,
    		PRO_CHEC,
    		GIV_BAC
	} state_t;

	state_t state, next;
	reg [9:0] payment;
	reg [9:0] balance;
	reg [7:0] price [0:31];
	reg afford;
	reg [3:0] i;
	reg trans_completed;
	initial begin
		//price initializtion
		// ── Drinks (slots 0–7) ──────────────────────────────────────
    			price[0]  <= 8'd85;    // Water              $0.85
    			price[1]  <= 8'd125;   // Cola               $1.25
    			price[2]  <= 8'd125;   // Diet Cola          $1.25
    			price[3]  <= 8'd150;   // Energy Drink       $1.50
    			price[4]  <= 8'd110;   // Orange Juice       $1.10
    			price[5]  <= 8'd110;   // Apple Juice        $1.10
    			price[6]  <= 8'd200;   // Iced Coffee        $2.00
    			price[7]  <= 8'd175;   // Chocolate Milk     $1.75

    		// ── Chips & Crisps (slots 8–12) ─────────────────────────────
    			price[8]  <= 8'd75;    // Plain Chips        $0.75
    			price[9]  <= 8'd75;    // BBQ Chips          $0.75
    			price[10] <= 8'd75;    // Cheese Chips       $0.75
    			price[11] <= 8'd90;    // Pretzels           $0.90
    			price[12] <= 8'd90;    // Popcorn            $0.90

    		// ── Sweets & Chocolate (slots 13–18) ────────────────────────
    			price[13] <= 8'd65;    // Candy Bar          $0.65
    			price[14] <= 8'd65;    // Gummy Bears        $0.65
    			price[15] <= 8'd80;    // Chocolate Bar      $0.80
    			price[16] <= 8'd80;    // Wafer Bar          $0.80
    			price[17] <= 8'd60;    // Chewing Gum        $0.60
    			price[18] <= 8'd100;   // Cookies Pack       $1.00

    		// ── Light Meals (slots 19–23) ────────────────────────────────
    			price[19] <= 8'd225;   // Sandwich           $2.25
    			price[20] <= 8'd175;   // Wrap               $1.75
    			price[21] <= 8'd250;   // Noodle Cup         $2.50
    			price[22] <= 8'd200;   // Rice Box           $2.00
    			price[23] <= 8'd150;   // Granola Bar        $1.50

    		// ── Health & Nuts (slots 24–27) ──────────────────────────────
    			price[24] <= 8'd120;   // Trail Mix          $1.20
    			price[25] <= 8'd115;   // Almonds Pack       $1.15
    			price[26] <= 8'd100;   // Dried Fruit        $1.00
    			price[27] <= 8'd130;   // Protein Bar        $1.30

    		// ── Personal Care (slots 28–31) ──────────────────────────────
    			price[28] <= 8'd150;   // Painkillers        $1.50
    			price[29] <= 8'd125;   // Lip Balm           $1.25
    			price[30] <= 8'd200;   // Hand Sanitiser     $2.00
    			price[31] <= 8'd175;   // Face Mask          $1.75
	end
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			state <= IDLE;
			balance   <= 0;
        		payment   <= 0;
        		pro_count <= 0;
			mo_out<=0;
			trans_done<=0;
			error<=0;
			shortfall  <= 0;
			mo_out     <= 0;
			cart_full  <= 0;
			mo_left<=0;
			trans_completed<=0;
			for (i = 0; i < 11; i = i + 1) cart[i] <= 0;
		end else begin
			state <= next;
			if (state == PRO_CHEC && (next == IDLE) && !conf) begin
            			trans_done <= 0;
            			error      <= 0;
				shortfall  <= 0;
        		end
			if (state == GIV_BAC) begin
				balance <= 0;
				payment<=0;
				pro_count<=0;
				trans_completed<=1;
			end
			if (state == IDLE && (pro_chose||check_out||tak_bac)) begin
    				balance    <= mo_lef;
				if (trans_completed) mo_out<=balance;
				else mo_out<=mo_lef;
    				trans_done <= 0;
    				error      <= 0;
    				shortfall  <= 0;
			end
			if (state == PRO_CHEC && add_mon) balance <= balance + mon_add;
			if (state == PRO_CHEC && conf) begin 
			   if (balance >= payment || pay_card) begin
				balance <= balance - payment;
				payment <= 0;
				pro_count <=0;
				trans_done <=1;
				error<=0;
				shortfall<=0;
				trans_completed<=1;
				mo_left <= balance - payment;
				for (i=0; i<11; i=i+1) cart[i]<=0;
			   end else begin
				error<=1;
				shortfall <= payment - balance;
			   end
			end
			if (state == DIS_PRO && add) begin
			   if (pro_count < 11 && (payment + price[pro_detail]) <= 10'd1023) begin
            			payment <= payment + price[pro_detail];
            			cart[pro_count] <= pro_detail;
            			pro_count<= pro_count + 1;
			   end
        		end
			cart_full <= (pro_count >= 5'd11);
		end

	always @(*) begin
		next=state;
		displaying=0;
		afford=(balance>=payment);
		for (i=0; i<11; i=i+1) pro_out[i]=0;

		case (state)
			IDLE: 	if (tak_bac) next=GIV_BAC;
				else if (check_out) next=PRO_CHEC;
				else if (pro_chose) next=DIS_PRO;

			GIV_BAC: next=IDLE;

			DIS_PRO: begin 
				displaying=pro_detail;
				if (back || timer) next=IDLE;	
				if (check_out) next=PRO_CHEC;
			end

			PRO_CHEC: begin
				if (conf) begin
					if (afford || pay_card) begin 
						for (i=0; i<pro_count; i=i+1) begin
							pro_out[i]=cart[i];
						end 
						next=IDLE;
					end
				end else if (timer || back) next=IDLE;
			end
			default: next=IDLE;
		endcase
	end
endmodule
