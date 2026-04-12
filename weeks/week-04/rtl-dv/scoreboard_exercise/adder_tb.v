`timescale 1ns/1ps
module adder_tb;
	reg [2:0] oper;
	reg [7:0] num_a;
	reg [7:0] num_b;
	reg cin;
	wire cout;
	wire [7:0] ans;
	wire neg, zer, ovf;
adder_dut dut (.oper(oper),.num_a(num_a),.num_b(num_b),.cin(cin),.cout(cout),.ans(ans),.neg(neg),.zer(zer),.ovf(ovf));

localparam NOT_A = 3'd0;
localparam ADD = 3'd1;
localparam SUB = 3'd2;
localparam AND = 3'd3;
localparam OR = 3'd4;
localparam XOR = 3'd5;
localparam SHI_RI = 3'd6;
localparam SHI_LE = 3'd7;

localparam SEED=42;

integer toca, faca, suca,o0, o1, o2, o3, o4, o5, o6, o7;
initial begin
	toca=0;
	faca=0;
	suca=0;
	o0=0;
	o1=0;
	o2=0;
	o3=0;
	o4=0;
	o5=0;
	o6=0;
	o7=0;
end

reg nega, zero, ovfl;
reg cou;
reg [7:0] answ;

task check;
input [2:0] opera;
input [7:0] nin_a;
input [7:0] nin_b;
input cinp;
begin
	cou=0;
	answ='0;
	oper  = opera;
    	num_a = nin_a;
    	num_b = nin_b;
    	cin   = cinp;
    	#10;
	toca=toca+1;
	case (opera)
		NOT_A: begin
			answ=~nin_a;
			o0=o0+1;
		end
		ADD: begin
			{cou,answ} = nin_a+nin_b+cinp;
			o1=o1+1;
		end
		SUB: begin
			answ= nin_a-nin_b-cinp;
			o2=o2+1;
		end
		AND: begin
			answ = nin_a & nin_b;
			o3=o3+1;
		end
		OR: begin
			answ= nin_a | nin_b;
			o4=o4+1;
		end
		XOR: begin
			answ = nin_a ^ nin_b;
			o5=o5+1;
		end
		SHI_RI: begin
			answ = nin_a >> nin_b[2:0];
			o6=o6+1;
		end
		SHI_LE: begin
			answ = nin_a << nin_b[2:0];
			o7=o7+1;
		end
	endcase
	nega = (answ[7]==1'b1);
	zero = (answ == {8{1'b0}});
	ovfl = (opera==ADD) ? cou : (opera==SUB) ? (nin_b > nin_a) :  1'b0;

	if ((neg==nega)&&(zero==zer)&&(ovfl==ovf)&&(cou==cout)&&(answ==ans)) 
	begin
		//$display("[SUCCESS]Test passed");
		suca=suca+1;
	end else begin
		$display("[FAIL]Test failed with a=%0d, b=%0d, expected ans=%0d, actual ans=%0d",nin_a, nin_b, answ, ans);
		case (opera)
			NOT_A: $display("NOT operation");
			ADD: $display("ADD operation");
			SUB: $display("SUB operation");
			AND: $display("AND operation");
			OR: $display("OR operation");
			XOR: $display("XOR operation");
			SHI_RI: $display("SHIFT RIGHT operation");
			SHI_LE: $display("SHIFT LEFT operation");
		endcase
		faca=faca+1;
	end
end
endtask

integer i;

initial begin
	$dumpfile("out.vcd");
	$dumpvars(0, dut);
	for (i=0; i<10000; i=i+1) begin
		check($urandom_range(0,7),$urandom_range(0,255),$urandom_range(0,255),$urandom_range(0,1));
	end
	$display("+-----------------------------------------+");
	$display("|            Scoreborad result            |");
	$display("+-----------------------------------------+");
	$display("           Number of tests: %d",toca);
	$display("           Successful tests: %d",suca);
	$display("           Failed tests:  %d",faca);
	$display("+-----------------------------------------+");
	$display("|                Coverage:                |");
	$display("+-----------------------------------------+");
	$display("             NOT tests: %d",o0); 
	$display("             ADD tests: %d",o1);
	$display("             SUB tests: %d",o2);
	$display("             AND tests: %d",o3);
	$display("             OR tests: %d",o4);
	$display("             XOR tests: %d",o5);
	$display("          SHIFT LEFT tests: %d",o6);
	$display("          SHIFT RIGHT tests: %d",o7);
	$display("-------------------------------------------");
	$finish;
end
endmodule