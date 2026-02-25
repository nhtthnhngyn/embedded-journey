#include <stdint.h>
#include <stdio.h>
static int hex_value(char c) {
    if (c >= '0' && c <= '9') return (int)(c - '0');
    if (c >= 'a' && c <= 'f') return (int)(10 + (c - 'a'));
    if (c >= 'A' && c <= 'F') return (int)(10 + (c - 'A'));
    return -1;
}
static int is_sep(char c) {
    return (c == ' ' || c == ',' || c == '_');
}
static void print_hex2_upper(uint8_t b) {
    static const char *hex = "0123456789ABCDEF";
    putchar(hex[(b >> 4) & 0xF]);
    putchar(hex[b & 0xF]);
    putchar('\n');
}
int main(void) {
    char s[100005];
    if (!fgets(s, (int)sizeof(s), stdin)) {
        printf("0\n0\n00\n");
        return 0;
    }
    uint32_t n = 0;
    uint8_t x = 0;
    int have_hi = 0;
    int hi = 0;
    for (size_t i = 0; s[i] != '\0'; i++) {
        char c = s[i];
        if (c == '\n' || c == '\r') continue;
        if (is_sep(c)) continue;
        int v = hex_value(c);
        if (v < 0) {
            printf("INVALID\n");
            return 0;
        }
        if (!have_hi) {
            hi = v;
            have_hi = 1;
        } else {
            int lo = v;
            uint8_t b = (uint8_t)((hi << 4) | lo);
            x ^= b;
            n++;
            have_hi = 0;
        }
    }
    if (have_hi) {
        printf("INVALID\n");
        return 0;
    }
    printf("%u\n", (unsigned)n);
    printf("%u\n", (unsigned)x);
    print_hex2_upper(x);
    return 0;
}
