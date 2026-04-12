#!/bin/bash

BUGS=("" "BUG_ADD_SUBTRACT" "BUG_IGNORE_CIN" "BUG_TRUNCATE" "BUG_SWAP_PLACE" "BUG_LOGICAL_AND" "BUG_LOGICAL_OR" "BUG_WRONG_DIRECTION")
LABELS=("CLEAN" "SUB_INSTEAD_OF_ADD" "NO_CIN" "TRUNCATE" "SWAP_POSITION_IN_SUBTRACTION" "USING_&&_INSTEAD_OF_&" "USING_||_INSTEAD_OF_|" "RIGHT_SHIFT_INSTEAD_LEFT")

echo "+-----------------------------------------------------------------------------+"
echo "|                      ADDER Bug Injection Matrix Results                     |"
echo "+-----------------------------------------------------------------------------+"
echo "|        BUG          |           DESCRIPTION                |    CAUGHT      | "
echo "+-----------------------------------------------------------------------------+"

for i in "${!BUGS[@]}"; do
	BUG=${BUGS[$i]}
	LABEL=${LABELS[$i]}

	if [ -z "$BUG" ]; then
    		FLAGS=""
  	else
    		FLAGS="-D$BUG"
  	fi
	iverilog "$FLAGS" -o sim adder_dut.v adder_tb.v 2>/dev/null
  	OUTPUT=$(vvp sim 2>&1)

	FAILS=$(echo "$OUTPUT" | grep -c "\[FAIL]")

	if [ "$BUG" = "" ]; then
    		STATUS=$([ $FAILS -eq 0 ] && echo "  OK    " || echo "  BAD  ")
  	else
    		STATUS=$([ $FAILS -gt 0 ] && echo "  CAUGHT" || echo "  MISSED")
  	fi

  	printf "| %-19s | %-36s | %-14s |\n" "$BUG" "$LABEL" "$STATUS"
done

echo "+-----------------------------------------------------------------------------+"

