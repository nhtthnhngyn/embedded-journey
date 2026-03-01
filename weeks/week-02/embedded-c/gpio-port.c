//A microcontroller's GPO port configuration register (32-bit) 
//// (a) Extracts the current ALT_FUNC field value (bits 15:12)
///// (b) Extracts the current MODE field value (bits 5:4)
///// (c) Sets MODE=0b10 (alternate), SPEED=0b10 (high), ALT_FUNC=0b0001 (UART)
/////     PULL=0b01 (pull-up), OTYPE=0b00 (push-pull)
/////     WITHOUT disturbing bits 31:16 (reserved upper half) or bits 3:0
///// (d) Write a reusable macro: FIELD_SET(reg, val, shift, mask)
/////     that inserts 'val' into 'reg' at position 'shift' with given 'mask'


#include <stdint.h>
#include <stdio.h>

//define each field's positon
#define ALT_FUNC 12
#define PULL 10
#define SPEED 8
#define OTYPE 6
#define MODE 4

//define the mask(width) of each field
#define ALT_FUNC_MASK ((1<<4)-1)<<ALT_FUNC
#define PULL_MASK ((1<<2)-1)<<PULL
#define SPEED_MASK ((1<<2)-1)<<SPEED
#define OTYPE_MASK ((1<<2)-1)<<OTYPE
#define MODE_MASK ((1<<2)-1)<<MODE

//reusablemacro reset reg at position shift to val with a mask
#define FIELD_SET(reg, val, shift, mask) (reg = (reg&~mask)|((val<<shift)&mask))
int main()
{
	uint32_t gpio;
	if (scanf("%x",&gpio) != 1) {
		printf("Wrong input\n");
		return 1;
	} else {
		uint8_t alt_func_val, mode_val;
		uint32_t modify_gpio,reg;
		//extract value of alt_func
		alt_func_val = (gpio>>ALT_FUNC)&((1<<4)-1);
		//extract value of mode
		mode_val = (gpio>>MODE) & ((1<<2)-1);
		//reset value at those fields
		uint32_t full_mask= ALT_FUNC_MASK | PULL_MASK | SPEED_MASK | OTYPE_MASK | MODE_MASK;
		modify_gpio=gpio&~full_mask;
		modify_gpio |= (0b10<<MODE) | (0b10<<SPEED) | (0b001<<ALT_FUNC) | (0b01<<PULL) | (0b00<<OTYPE);
		reg=gpio;
		printf("%d\n%d\n",alt_func_val, mode_val);
		printf("%x\n",modify_gpio);
		printf("%x\n",FIELD_SET(reg, 0x1, PULL, PULL_MASK));

	}
	return 0;
}
