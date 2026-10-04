#include <stdio.h>

int main() {
    int n, a[20][2], f[20], mark[20][20] = {0};

    printf("Enter number of states: ");
    scanf("%d", &n);

    printf("Enter transition table (for inputs 0 and 1):\n");
    for (int i = 0; i < n; i++) {
        printf("State %d: ", i);
        scanf("%d%d", &a[i][0], &a[i][1]);
    }

    printf("Enter final states (1=Final, 0=Non-final):\n");
    for (int i = 0; i < n; i++) {
        printf("State %d: ", i);
        scanf("%d", &f[i]);
    }

    for (int i = 0; i < n; i++)
        for (int j = i + 1; j < n; j++)
            if (f[i] != f[j])
                mark[i][j] = 1;

    int change;
    do {
        change = 0;
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                if (!mark[i][j]) {
                    for (int k = 0; k < 2; k++) {
                        int x = a[i][k], y = a[j][k];
                        if (x > y) {
                            int t = x;
                            x = y;
                            y = t;
                        }
                        if (mark[x][y]) {
                            mark[i][j] = 1;
                            change = 1;
                            break;
                        }
                    }
                }
            }
        }
    } while (change);

    printf("\nEquivalent States:\n");
    for (int i = 0; i < n; i++)
        for (int j = i + 1; j < n; j++)
            if (!mark[i][j])
                printf("%d and %d\n", i, j);

    return 0;
}
