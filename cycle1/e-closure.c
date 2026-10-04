#include <stdio.h>

#define MAX 10

int n;
int e[MAX][MAX];

// Function to find epsilon closure using DFS
void epsilonClosure(int state, int visited[]) {
    int i;
    visited[state] = 1;
    printf("q%d ", state);

    for (i = 0; i < n; i++) {
        if (e[state][i] && !visited[i]) {
            epsilonClosure(i, visited);
        }
    }
}

int main() {
    int i, j;
    int visited[MAX];

    printf("Enter the number of states: ");
    scanf("%d", &n);

    printf("Enter the epsilon transition matrix (0 or 1):\n");
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            scanf("%d", &e[i][j]);
        }
    }

    printf("\nEpsilon Closures:\n");
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++)
            visited[j] = 0;

        printf("ε-Closure(q%d) = { ", i);
        epsilonClosure(i, visited);
        printf("}\n");
    }

    return 0;
}