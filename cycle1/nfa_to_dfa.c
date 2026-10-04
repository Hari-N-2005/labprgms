#include <stdio.h>

int n, m;
int t[10][2][10];
int dfa[10][10], count = 1;

int main()
{
    scanf("%d%d", &n, &m);

    for (int i = 0; i < m; i++) {
        int a, b, c;
        scanf("%d%d%d", &a, &b, &c);
        t[a][b][c] = 1;
    }

    dfa[0][0] = 1;   // Start state = {0}

    for (int d = 0; d < count; d++) {

        printf("{ ");
        for (int i = 0; i < n; i++)
            if (dfa[d][i])
                printf("%d ", i);
        printf("}");

        for (int x = 0; x < 2; x++) {

            int next[10] = {0};

            for (int i = 0; i < n; i++)
                if (dfa[d][i])
                    for (int j = 0; j < n; j++)
                        if (t[i][x][j])
                            next[j] = 1;

            printf(" --%d--> { ", x);

            for (int i = 0; i < n; i++)
                if (next[i])
                    printf("%d ", i);

            printf("}");

            /* Add next state if it is new */
            int new = 1;

            for (int k = 0; k < count; k++) {
                int same = 1;

                for (int i = 0; i < n; i++)
                    if (dfa[k][i] != next[i])
                        same = 0;

                if (same)
                    new = 0;
            }

            if (new) {
                for (int i = 0; i < n; i++)
                    dfa[count][i] = next[i];

                count++;
            }
        }

        printf("\n");
    }
}