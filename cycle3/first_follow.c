
#include <stdio.h>
#include <string.h>

char p[10][20], first[26][20], follow[26][20];
int n;

int isNT(char c) {
    return c >= 'A' && c <= 'Z';
}

int add(char set[], char c) {
    if (strchr(set, c)) return 0;
    int l = strlen(set);
    set[l] = c;
    set[l + 1] = '\0';
    return 1;
}

void findFirst() {
    int change;

    do {
        change = 0;

        for (int i = 0; i < n; i++) {
            char A = p[i][0], *rhs = p[i] + 3;

            if (rhs[0] == '#') {
                change |= add(first[A-'A'], '#');
                continue;
            }

            for (int j = 0; rhs[j]; j++) {
                char c = rhs[j];

                if (!isNT(c)) {
                    change |= add(first[A-'A'], c);
                    break;
                }

                for (int k = 0; first[c-'A'][k]; k++)
                    if (first[c-'A'][k] != '#')
                        change |= add(first[A-'A'],
                                      first[c-'A'][k]);

                if (!strchr(first[c-'A'], '#'))
                    break;

                if (!rhs[j+1])
                    change |= add(first[A-'A'], '#');
            }
        }
    } while (change);
}

void findFollow() {
    add(follow[p[0][0]-'A'], '$');

    int change;

    do {
        change = 0;

        for (int i = 0; i < n; i++) {
            char A = p[i][0], *rhs = p[i] + 3;

            for (int j = 0; rhs[j]; j++) {
                char B = rhs[j];

                if (!isNT(B)) continue;

                int nullable = 1;

                for (int k = j+1; rhs[k]; k++) {
                    char c = rhs[k];

                    if (!isNT(c)) {
                        change |= add(follow[B-'A'], c);
                        nullable = 0;
                        break;
                    }

                    for (int x = 0; first[c-'A'][x]; x++)
                        if (first[c-'A'][x] != '#')
                            change |= add(follow[B-'A'],
                                          first[c-'A'][x]);

                    if (!strchr(first[c-'A'], '#')) {
                        nullable = 0;
                        break;
                    }
                }

                if (nullable)
                    for (int k = 0; follow[A-'A'][k]; k++)
                        change |= add(follow[B-'A'],
                                      follow[A-'A'][k]);
            }
        }
    } while (change);
}

int main() {
    printf("Enter number of productions: ");
    if (scanf("%d", &n) != 1 || n < 1 || n > 10) {
        printf("Invalid number of productions.\n");
        return 1;
    }

    printf("Enter productions (use # for epsilon):\n");

    for (int i = 0; i < n; i++)
        scanf("%19s", p[i]);

    findFirst();
    findFollow();

    char seen[26] = {0};

    printf("\nFIRST:\n");
    for (int i = 0; i < n; i++) {
        char A = p[i][0];

        if (!seen[A-'A']) {
            printf("FIRST(%c) = { %s }\n",
                   A, first[A-'A']);
            seen[A-'A'] = 1;
        }
    }

    char seen2[26] = {0};

    printf("\nFOLLOW:\n");
    for (int i = 0; i < n; i++) {
        char A = p[i][0];

        if (!seen2[A-'A']) {
            printf("FOLLOW(%c) = { %s }\n",
                   A, follow[A-'A']);
            seen2[A-'A'] = 1;
        }
    }

    return 0;
}