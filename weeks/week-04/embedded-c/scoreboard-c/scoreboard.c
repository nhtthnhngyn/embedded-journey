#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct {
    uint8_t cout;
    uint8_t ans;
    uint8_t neg;
    uint8_t zer;
    uint8_t ovf;
} Element;

typedef struct Node{
    Element cur;
    struct Node* next;
} Node;

typedef struct {
    Node* head;
    Node* tail;
    size_t size;
} Queue;

void queue_init(Queue* q) {
    q->head = NULL;
    q->tail = NULL;
    q->size = 0;
}

void queue_push(Queue* q, Element *elem) {
    Node* new_node = (Node*)malloc(sizeof(Node));
    new_node->cur = *elem;
    new_node->next = NULL;
    if (q->tail) {
        q->tail->next = new_node;
    } else {
        q->head = new_node;
    }
    q->tail = new_node;
    q->size++;
}

int queue_pop(Queue* q, Element *elem) {
    if (q->size == 0) {
        return -1; // Queue is empty
    }
    Node* temp = q->head;
    *elem = temp->cur;
    q->head = q->head->next;
    free(temp);
    q->size--;
    if (q->size == 0) {
        q->tail = NULL;
    }
    return 0; // Success
}

int queue_peek(Queue* q, Element *elem) {
    if (q->size == 0) {
        return -1; // Queue is empty
    }
    *elem = q->head->cur;
    return 0; // Success
}

int queue_empty(Queue* q) {
    return q->size == 0;
}

size_t queue_size(Queue* q) {
    return q->size;
}

void queue_free(Queue* q) {
    while (!queue_empty(q)) {
        Element elem;
        queue_pop(q, &elem);
    }
}

void queue_print(Queue* q) {
    printf("Queue elements:\n");
    if (queue_empty(q)) {
        printf("Queue is empty\n");
        return;
    }
    Node* current = q->head;
    while (current) {
        printf("Element: %d\n", current->cur.ans);
        current = current->next;
    }
}

typedef struct {
    Queue expected;
    Queue actual;
    uint32_t pass_count;
    uint32_t fail_count;
    uint32_t total_count;
    int verbose;
} Scoreboard;

void sb_init(Scoreboard* sb) {
    queue_init(&sb->expected);
    queue_init(&sb->actual);
    sb->pass_count = 0;
    sb->fail_count = 0;
    sb->total_count = 0;
    sb->verbose = 0;
}

typedef struct {
    int cout_match;
    int ans_match;
    int neg_match;
    int zer_match;
    int ovf_match;
    int overall_pass;
} MatchResult;

MatchResult ele_compare(Element* expected, Element* actual) {
    MatchResult result;
    result.cout_match = (expected->cout == actual->cout);
    result.ans_match = (expected->ans == actual->ans);
    result.neg_match = (expected->neg == actual->neg);
    result.zer_match = (expected->zer == actual->zer);
    result.ovf_match = (expected->ovf == actual->ovf);
    result.overall_pass = (result.cout_match && result.ans_match && result.neg_match && result.zer_match && result.ovf_match);
    return result;
}

void cmp_print(const Element *exp, const Element *act, MatchResult *res, uint32_t test_num) {
    printf("Test #%u: ", test_num);
    if (res->overall_pass) {
        printf("[PASS]\n");
    } else {
        printf("[FAIL]\n");
        printf("Field Mismatches:\n");
        if (!res->cout_match) {
            printf("  cout: expected %d, got %d\n", exp->cout, act->cout);
        }
        if (!res->ans_match) {
            printf("  ans: expected %d, got %d\n", exp->ans, act->ans);
        }
        if (!res->neg_match) {
            printf("  neg: expected %d, got %d\n", exp->neg, act->neg);
        }
        if (!res->zer_match) {
            printf("  zer: expected %d, got %d\n", exp->zer, act->zer);
        }
        if (!res->ovf_match) {
            printf("  ovf: expected %d, got %d\n", exp->ovf, act->ovf);
        }
    }
}

void sb_check(Scoreboard* sb) {
    Element expected, actual;
    MatchResult result;
    uint32_t test_num = 1;

    while (!queue_empty(&sb->expected) && !queue_empty(&sb->actual)) {
        queue_pop(&sb->expected, &expected);
        queue_pop(&sb->actual, &actual);
        result = ele_compare(&expected, &actual);
        cmp_print(&expected, &actual, &result, test_num++);
        if (result.overall_pass) {
            sb->pass_count++;
        } else {
            sb->fail_count++;
        }
        sb->total_count++;
    }
}

void sb_report(Scoreboard *sb) {
    printf("\n+---------------------------+\n");
    printf("|           Test Summary     |\n");
    printf("+----------------------------+\n");
    printf("| Total: %u                  |\n", sb->total_count);
    printf("| Pass:  %u                  |\n", sb->pass_count);
    printf("| Fail:  %u                  |\n", sb->fail_count);
    printf("+---------------------------+\n");
    if (sb->fail_count == 0) {
        printf("| All tests passed successfully!|\n");
    }
}

void sb_free(Scoreboard *sb) {
    queue_free(&sb->expected);
    queue_free(&sb->actual);
}

int main(void) {
    Scoreboard sb;
    sb_init(&sb);

    Element exp1 = {0, 42, 0, 0, 0};
    Element act1 = {0, 42, 0, 0, 0};
    queue_push(&sb.expected, &exp1);
    queue_push(&sb.actual, &act1);

    Element exp2 = {0, 100, 0, 0, 0};
    Element act2 = {0, 99, 0, 0, 0};
    queue_push(&sb.expected, &exp2);
    queue_push(&sb.actual, &act2);

    sb_check(&sb);
    sb_report(&sb);
    sb_free(&sb);
    return 0;
}
