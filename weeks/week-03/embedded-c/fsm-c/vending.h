#pragma once
#include <stdint.h>
#include <stdio.h>
#include <string.h>

typedef enum {IDLE, GIV_BAC, DIS_PRO, PRO_CHEC} state_t;

typedef struct {
	state_t state;
	state_t next;
	uint16_t payment;
	uint16_t balance;
	uint8_t price[32];
	int trans_completed;
	uint16_t mo_out;
	uint16_t mo_left;
	uint16_t shortfall;
	uint8_t displaying;
	uint8_t pro_out[11];
	uint8_t cart[11];
	uint8_t pro_count;
	int trans_done;
	int error;
	int cart_full;
} VendingState;

typedef struct {
	int rst_n;
	uint16_t mo_lef;
	int add_mon;
	uint16_t mon_add;
	int tak_bac;
	int pay_card;
	int pro_chose;
	uint8_t pro_detail;
	int add;
	int back;
	int timer;
	int check_out;
	int conf;
} VendingInput;

void vending_init(VendingState *s);
void vending_tick(VendingState *s, VendingInput in);
