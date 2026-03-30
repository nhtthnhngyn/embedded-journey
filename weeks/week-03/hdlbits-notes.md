1. Declare vector input wire [2:0] a
2. Endianness (direction) of a vector is whether the least significant bit has a lower index (little-endian, [3:0]) or a higher index (big-endian, [0:3])
3. When declare wire wire [3:0] vec -> vec[0:3] is illegal
4. Implicit nets are always one-bit wires (wire [2:0] a;  assign b=a => b=1 (implicit nets)
5. packed reg [7:0] a, unpacked reg b[7:0] => use -g2002
6. part-select must match the direction of the declaration a= b[5:3]
7. concatenation {a[2:0],b[2:0]}
8. always @(*) begin
	for (int i=0; i<8;i++)
		out[i]=in[8-i-1];
end (procedural loop-SystemVerilog style)

generate
	genvar i;
	for (i=0; i<8; i=i+1) begin my_block_name
		assign out[i]=in[8-i-1];
	end
endgenerate (generate loop make instantiations of things-Quartus requires a generate-for loop to have a nameed begin-end block, genvars are read only)

9. {3'd5, {2{3'd6}}}
10. Use Sum (OR) of product (AND) to describe truth table
11. module A (input a,input b,ouput c);
assign c=(a==b);
endmodule

module top_module(input x, input y, output z);
wire o1;
A ia1 (x,y,o1); //(use module A and name it ia1)
assign z=o1^x;
endmodule

12. assign out_both =in & in[99:1] (truncate from the MSB side, LSB is always preserved)


