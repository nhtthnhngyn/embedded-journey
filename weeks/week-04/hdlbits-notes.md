1. Hierarchy - modules can contain instances of other modules 
2. Connecting signals to module ports: 
- By position: mod_a instance1 (wa, wb,wc);
- By name: mod_a instance2 (.a(wa),.b(wb),.c(wc);
3. If vector length of the port != wire connecting to it -> zero-padding or truncation
4. Could use always @(*) and case for selection type
5. When using adder module, remember to integrate the carry in, carry out
6. if must be put in the procedural zone
7. a+b = a+~b+1 ->use sub as cin and xored b with it
8. For synthesizing hardware, two types of always blocks are relevant:
- Combinational: always @(*)
- Clocked: always @(posedge clk)->create combinational blocks+ a set of flip-flops => Instead of being visible immediately, the outpus are visible only immediately after the next (posedge clk)
=> The syntax for code inside a procedural block is different from code that is outside
- LHS of an assign statement: net type (e.g.,wire)
- LHS of a procedural assignment (always): variable type (e.g.,reg)
9. Three types of assignments:
- Continuous (assign x=y) not in a procedure
- Procedural blocking (x=y) in combinational always block
- Procedural non-blocking (x<=y) in clocked always block
10. Conditional operator
- assign out = (condition) ? x:y;
11. cases other than those specified -> keep outputs unchanged -> create a latch (remember and hold the last value forever)
12. case (in)
	1'b1:
	1'b2:
	default:
endcase -> do not need break, allow duplicates but just the first one is used
13. casez: It treats bits that have the value z as don't care in the comparison
- 2'bz0=2'b?0
- First match if have multiple -> order matters
14. writing the default value at first -> avoid latch
