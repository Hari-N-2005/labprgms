#include <stdio.h>
#include <string.h>

char stack[50], input[50];
int top = 0, i = 0;

int precedence(char c)
{
    if (c == '+')
        return 1;
    if (c == '*')
        return 2;
    return 0;
}

void reduce()
{
    if (stack[top] == 'i')
    {
        stack[top] = 'E';
        printf("Reduce i to E\n");
    }
    else if (top >= 2 && stack[top] == 'E')
    {
        if (stack[top - 1] == '+' || stack[top - 1] == '*')
        {
            if (stack[top - 2] == 'E')
            {
                top = top - 2;
                stack[top] = 'E';
                printf("Reduce E op E to E\n");
            }
        }
    }
}

int main()
{
    printf("Enter expression using i: ");
    scanf("%s", input);

    strcat(input, "$");

    stack[0] = '$';

    while (input[i] != '$')
    {
        if (input[i] == 'i')
        {
            stack[++top] = input[i++];
            reduce();
        }
        else if (precedence(input[i]) > precedence(stack[top]))
        {
            stack[++top] = input[i++];
            printf("Shift\n");
        }
        else
        {
            reduce();
        }
    }

    while (top > 1)
        reduce();

    if (top == 1 && stack[1] == 'E')
        printf("Accepted\n");
    else
        printf("Rejected\n");

    return 0;
}