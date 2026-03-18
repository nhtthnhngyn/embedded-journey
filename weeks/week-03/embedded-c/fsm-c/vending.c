#include "vending.h"

void vending_init(VendingState *s) {
    memset(s, 0, sizeof(*s));
    s->state = IDLE;
    /* Drinks */
    s->price[0]=85;  s->price[1]=125; s->price[2]=125; s->price[3]=150;
    s->price[4]=110; s->price[5]=110; s->price[6]=200; s->price[7]=175;
    /* Chips */
    s->price[8]=75;  s->price[9]=75;  s->price[10]=75;
    s->price[11]=90; s->price[12]=90;
    /* Sweets */
    s->price[13]=65; s->price[14]=65; s->price[15]=80; s->price[16]=80;
    s->price[17]=60; s->price[18]=100;
    /* Light meals */
    s->price[19]=225; s->price[20]=175; s->price[21]=250;
    s->price[22]=200; s->price[23]=150;
    /* Health */
    s->price[24]=120; s->price[25]=115; s->price[26]=100; s->price[27]=130;
    /* Personal care */
    s->price[28]=150; s->price[29]=125; s->price[30]=200; s->price[31]=175;
}

void vending_tick(VendingState *s, VendingInput in) {
	if (!in.rst_n) {
		s->state = IDLE;  s->balance = 0;  s->payment = 0;
	        s->pro_count = 0; s->mo_out = 0;   s->trans_done = 0;
	        s->error = 0;     s->shortfall = 0; s->cart_full = 0;
        	s->mo_left = 0;   s->trans_completed = 0;
	        for (int i = 0; i < 11; i++) s->cart[i] = 0;
	        return;
	}
	state_t cur_state=s->state;
	uint16_t cur_bal=s->balance;
	uint16_t cur_pay=s->payment;
	uint8_t cur_count=s->pro_count;

	s->next=cur_state;
	s->displaying=0;
	int afford =(s->balance>=s->payment);
	for (int i=0; i<11; i=i+1) s->pro_out[i]=0;
	switch (s->state) {
		case IDLE: if (in.check_out) s->next=PRO_CHEC;
			else if (in.tak_bac) s->next=GIV_BAC;
			else if (in.pro_chose) s->next=DIS_PRO;
			break;
		case GIV_BAC: s->next=IDLE; break;
		case DIS_PRO: s->displaying=in.pro_detail;
		              if (in.back || in.timer) s->next=IDLE;
			      if (in.check_out) s->next=PRO_CHEC;
			      break;
		case PRO_CHEC: if (in.conf) {
					if (afford || in.pay_card) {
						for (int i=0; i<cur_count;i=i+1) s->pro_out[i]=s->cart[i];
					s->next=IDLE;
					}
				} else if (in.timer || in.back) s->next=IDLE;
				break;
		default: s->next=IDLE;
	}
	s->state=s->next;
	if (cur_state==PRO_CHEC && (s->next==IDLE) && !in.conf) {
		s->trans_done=0;
		s->error=0;
		s->shortfall=0;
	}

	if (cur_state==GIV_BAC) {
		s->balance=0;
		s->payment=0;
		s->pro_count=0;
		s->trans_completed=1;
	}

	if (cur_state==IDLE && (in.pro_chose||in.check_out||in.tak_bac)) {
		s->balance=in.mo_lef;
		cur_bal=s->balance;
		if (s->trans_completed) s->mo_out=cur_bal;
		else s->mo_out=in.mo_lef;
		s->trans_done=0;
		s->error=0;
		s->shortfall=0;
	}

	if (cur_state==PRO_CHEC && in.add_mon) s->balance=s->balance+in.mon_add;

	if (cur_state==PRO_CHEC && in.conf) {
	   if (cur_bal>=cur_pay || in.pay_card) {
		s->balance=cur_bal-cur_pay;
		s->payment=0;
		s->pro_count=0;
		s->trans_done=1;
		s->error=0;
		s->shortfall=0;
		s->trans_completed=1;
		s->mo_left=cur_bal-cur_pay;
		for (int i=0; i<11;i=i+1) s->cart[i]=0;
	   } else {
		s->error=1;
		s->shortfall=(uint16_t)(cur_bal-cur_pay);
		}
	}

	if (cur_state ==DIS_PRO && in.add) {
		if (cur_count<11 && (cur_pay+s->price[in.pro_detail])<=1023) {
			s->payment=cur_pay+s->price[in.pro_detail];
			s->cart[cur_count]=in.pro_detail;
			s->pro_count=cur_count+1;
		}
	}
	s->cart_full=(s->pro_count>=11);
}

