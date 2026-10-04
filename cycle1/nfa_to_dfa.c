#include <stdio.h>

int n, m, t[10][2], vis[1024], q[1024], f = 0, r = 0;

int main() {
    printf("Enter number of NFA states: ");
    scanf("%d", &n);

    printf("Enter number of transitions: ");
    scanf("%d", &m);

    printf("Enter transitions as: from_state input(0/1) to_state\n");
    for (int i = 0; i < m; i++) {
        int u, c, v;
        printf("Transition %d: ", i + 1);
        scanf("%d%d%d", &u, &c, &v);
        t[u][c] |= 1 << v;
    }

    printf("\nDFA Transitions:\n");

    vis[1] = 1;
    q[r++] = 1;

    while (f < r) {
        int s = q[f++];

        printf("{");
        for (int i = 0; i < n; i++)
            if (s & (1 << i))
                printf("%d", i);
        printf("}");

        for (int c = 0; c < 2; c++) {
            int ns = 0;
            for (int i = 0; i < n; i++)
                if (s & (1 << i))
                    ns |= t[i][c];

            printf(" --%d--> {", c);
            for (int i = 0; i < n; i++)
                if (ns & (1 << i))
                    printf("%d", i);
            printf("}");

            if (!vis[ns]) {
                vis[ns] = 1;
                q[r++] = ns;
            }
        }
        printf("\n");
    }

    return 0;
}