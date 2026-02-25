#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
	uint8_t *data;
	size_t capacity;
	size_t head;
	size_t tail;
	size_t count;
} Ringbuf;

static int rb_init(Ringbuf *rb, size_t capacity) {
	rb->data= (uint8_t*)malloc(capacity);
	if (!rb->data) return -1;
	rb->capacity=capacity;
	rb->head = rb->tail = rb->count=0;
	return 0;
}

static void rb_free(Ringbuf *rb) {
	free(rb->data);
	rb->data=NULL;
	rb->capacity=rb->head=rb->tail=rb->count=0;
}

static int rb_push(Ringbuf *rb, uint8_t x) {
	if (rb->count == rb->capacity) return -1;
	rb->data[rb->tail] = x;
	rb->tail = (rb->tail + 1u) % rb->capacity;
	rb->count++;
	return 0;
}

static int rb_pop(Ringbuf *rb, uint8_t *out) {
	if (rb->count == 0) return -1;
	*out= rb->data[rb->head];
	rb->head= (rb->head +1u) % rb->capacity;
	rb->count--;
	return 0;
}

static int rb_peek(Ringbuf *rb, uint8_t *out) {
	if (rb->count == 0) return -1;
	*out = rb->data[rb->head];
	return 0;
}

int main(void) {
	size_t capacity = 0;
	if (scanf("%zu", &capacity) != 1 || capacity == 0 || capacity >4096) {
		fprintf(stderr, "Invalid capacity\n");
		return 1;
	}

	Ringbuf rb;
	if (rb_init(&rb, capacity) != 0) {
		fprintf(stderr, "Out of memory\n");
		return 1;
	}

	char cmd[16];
	while (scanf("%15s", cmd) == 1) {
		if (strcmp(cmd, "PUSH") ==0 ) {
			int x;
			if (scanf("%d", &x) != 1 || x<0 || x>255) {
				printf("ERR\n");
				break;
			}
			if (rb_push(&rb, (uint8_t)x) != 0) printf("FULL\n");
		} else if (strcmp(cmd, "POP") ==0) {
			uint8_t v;
			if (rb_pop(&rb, &v) != 0) printf("EMPTY\n");
			else printf("%u\n", (unsigned)v);
		} else if (strcmp(cmd, "PEEK") ==0) {
			uint8_t v;
			if (rb_peek(&rb, &v) != 0) printf("EMPTY\n");
			else printf("%u\n", (unsigned)v);
		} else if (strcmp(cmd, "SIZE") == 0) {
			printf("%zu\n", rb.count);
		} else {
			printf("ERR\n");
			break;
		}
	}

	rb_free(&rb);
	return 0;
}
