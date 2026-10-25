#include <stdio.h>
#include <string.h>

int main()
{
    char exp[100], tokens[100][10];
    int count = 0, temp = 1;

    printf("Enter expression: ");
    scanf("%s", exp);
    printf("\nThree Address Code:\n");

    for(int i = 0; exp[i] != '\0'; i++)
    {
        tokens[count][0] = exp[i];
        tokens[count][1] = '\0';
        count++;
    }

    for(int pass = 0; pass < 2; pass++)
    {
        for(int i = 1; i < count - 1; i++)
        {
            if((pass == 0 && (tokens[i][0] == '*' || tokens[i][0] == '/')) ||
               (pass == 1 && (tokens[i][0] == '+' || tokens[i][0] == '-')))
            {
                printf("t%d = %s %c %s\n",
                    temp, tokens[i - 1], tokens[i][0], tokens[i + 1]);
                sprintf(tokens[i - 1], "t%d", temp);
                for(int j = i; j < count - 2; j++)
                    strcpy(tokens[j], tokens[j + 2]);
                count -= 2;
                temp++;
                i--;
            }
        }
    }

    return 0;
}