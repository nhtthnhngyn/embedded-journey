// BRR = FCLK / (16 * BAUD)
// BRR register layout [31:0]:
//   bits [31:4]  = integer part of divider  (28 bits)
//   bits [3:0]   = fractional part * 16     ( 4 bits)

#include <stdio.h>
#include <stdint.h>

uint32_t uart_set_baud(uint32_t *fclk, uint32_t *baud) {
		uint32_t d,res=0;
		d=(*fclk)/(*baud);
		uint32_t a=d>>4;
		res|=(a<<4);
		//could also use res|=(d&0xF)
		res|=(d-a<<4);
		return res;
	}

int main() 
{
	uint32_t fclk, baud;
	//scan and save the variables
	scanf("%d %d",&fclk,&baud);
	printf("%d\n",uart_set_baud(&fclk,&baud));
	return 0;
}


