#include <stdint.h>
#include <stdio.h>

#define SIGN 31
#define SEVERITY 28
#define MODULE_ID 20
#define INSTANCE 16
#define ERROR_CODE 0

#define SIGN_WIDTH 1
#define SEVERITY_WIDTH 3
#define MODULE_ID_WIDTH 8
#define INSTANCE_WIDTH 4
#define ERROR_CODE_WIDTH 16

#define SIGN_MASK ((1<<SIGN_WIDTH)-1)<<SIGN
#define SEVERITY_MASK ((1<<SEVERITY_WIDTH)-1)<<SEVERITY
#define MODULE_ID_MASK ((1<<MODULE_ID_WIDTH)-1)<<MODULE_ID
#define INSTANCE_MASK ((1<<INSTANCE_WIDTH)-1)<<INSTANCE
#define ERROR_CODE_MASK ((1<<ERROR_CODE_WIDTH)-1)<<ERROR_CODE

#define MOD_SPI 0x01
#define MOD_I2C 0x02
#define MOD_UART 0x03
#define MOD_DMA 0x04

#define ERR_TIMEOUT 0x0001
#define ERR_CRC_FAIL 0x0002
#define ERR_OVERRUN 0x0003
#define ERR_BUS_BUSY 0x0004

#define SEV_INFO 0
#define SEV_WARN 1
#define SEV_RECOVER 2
#define SEV_FATAL 3
#define SET_HW_FAULT 4

int32_t make_error(uint8_t sev, uint8_t mod, uint8_t inst, uint16_t code) {
	return (int32_t)(ERROR_CODE_MASK|((uint32_t)(sev&0x7U)<<SEVERITY)|((uint32_t)(mod&0xFFU)<<MODULE_ID)|((uint32_t)(inst&0xFU)<<INSTANCE)|((uint32_t)(code&0xFFFF))); }

void decode_error(int32_t err) {
	if (!(err&ERROR_CODE_MASK)) { printf("OK\n"); return; }

	uint8_t sev = (err&SEVERITY_MASK)>>SEVERITY;
	uint8_t mod = (err&MODULE_ID_MASK)>>MODULE_ID;
	uint8_t ins = (err&INSTANCE_MASK)>>INSTANCE;
	uint8_t cod = (err&ERROR_CODE_MASK)>>ERROR_CODE;

	const char* seve;
	const char* modu;
	const char* codee;
	switch (sev) {
		case (0): seve="INFO"; break;
		case (1): seve="WARN"; break;
		case (2): seve="RECOVERABLE"; break;
		case (3): seve="FATAL"; break;
		default: seve="HW_FAULT"; }
	switch (mod) {
		case (0x01): modu="SPI"; break;
		case (0x02): modu="I2C"; break;
		case (0x03): modu="UART"; break;
		case (0x04): modu="DMA"; break;
		default: modu=""; }
	switch (cod) {
		case (0x0001): codee="TIMEOUT";break;
		case (0x0002): codee="CRC_FAIL";break;
		case (0x0003): codee="OVERRUN";break;
		default: codee="BUS_BUSY"; }
	printf("ERROR [%s] module=%s inst=%d code=%s\n",seve,modu,ins,codee);
}
int main()
{
	uint8_t se,mo,in;
	uint16_t co;
	scanf("%hhd %hhd %hhd %hd",&se,&mo,&in,&co);
	int32_t erro=make_error(se,mo,in,co);
	decode_error(erro);
	return 0;
}
