#FUNDAMENT OF IVERILOG

##Types and declarations 
- Signal driven from always/this module -> reg
- Driven from other module -> wire
- Have different zones allowing separated executions:
+ Structural zone for building real wire, real circuit (declaration,assign, ...)
+ Procedural zone for simulation (#delay, $dumpfile,...) and describing sequential, combinational behavior (if, case, always @(*),...)

##Blocking vs Non-Blocking
- always @(posedge clk) use <=
- always @(*) use =
- <= models real flip-flop physics and acts as two-phase execution
- = blocks later signal assignment, read the new value immediately

##Semsitivity list
- @(*) automatically includes every signal READ on the right-hand side
- Any of those signals change -> re-excute the block

##FSM - always use three separated blocks
- State register in @(posedge clk)
- Next-state logic in @(*)
- Output logic in @(*)

##Always write default in every case
- Unmatched value including x permanently breaks an FSM
-> Saves the machine when state is x before reset is applied

##Use === for test bech detection only
- Use == in desgin logic
- Use === in testbenches to detect uninitialised signals (x/z)
        
