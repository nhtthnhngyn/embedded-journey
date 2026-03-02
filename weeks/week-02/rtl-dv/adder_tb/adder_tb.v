`timescale 1ns/1ps

module adder_tb;

	reg[3:0] a;
	reg[3:0] b;
	reg cin;
	wire[3:0] sum;
	wire cout;
	reg[3:0]error;

	adder #(.WIDTH(4)) dut (
		.a(a),
		.b(b),
		.cin(cin),
		.sum(sum),
		.cout(cout)
);

initial begin
	$dumpfile("adder.vcd");
	$dumpvars(0,adder_tb);
end

task check;
	input[3:0] ta;
	input[3:0] tb;
	input tc;
	input[4:0] expec;
	begin
		a=ta;
		b=tb;
		cin=tc;
		#10;
		if ({cout,sum}==expec) 
			$display("PASS | a=%0d b=%0d cin=%0d => ans=%0d",a,b,cin,{cout,sum});
		else
			$display("FAIL | a=%0d b=%0d cin=%0d => expected: %0d but got %0d",a, b, cin, expec, {cout,sum});
	end
endtask

initial begin
	error=0;
	$display("===Testbench===");
	
	//manual check
	$display("--Manual check--");
	check(4'd0,4'd0,0,5'd0);
	check(4'd10, 4'd10,0,5'd20);
	check(4'd15, 4'd15,1,5'd31);
	
	//random test
	$display("--Random check--");
	repeat(10) begin
		a=$random;
		b=$random;
		cin=$random;
		#10;
		if ({cout,sum} === (a+b+cin))
			$display("PASS");
		else begin
			$display("FAIL");
			error=error+1;
		end
	end
	
	$display("==DONE==");
	if (error==0)
		$display("ALL PASS!");
	else
		$display("FAIL, ERRORS: %0d",error);
	$finish;
end
endmodule
