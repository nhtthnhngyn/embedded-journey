#include <stdio.h>
#include "vending.h"

int main(void) {
	VendingState s;
	VendingInput in={0};
	vending_init(&s);
	//reset everything
	in.rst_n=0;
	vending_tick(&s,in);
	//choose something
	in.rst_n=1;
	in.mo_lef=500;
	in.pro_chose=1;
	vending_tick(&s,in);
	in.pro_chose=0;
	//add that product to cart
	in.pro_detail=11;
	in.add=1;
	vending_tick(&s,in);
	in.add=0;
	//check out
	in.check_out=1;
	vending_tick(&s,in);
	in.check_out=0;
	//confirm buying
	in.conf=1;
	vending_tick(&s,in);
	in.conf=0;

	if (s.trans_done) printf("buying completed mo_left=%u price=%u\n",s.mo_left,s.price[in.pro_detail]);
	else printf("Error price=%u\n",s.price[in.pro_detail]);

	return 0;
}
