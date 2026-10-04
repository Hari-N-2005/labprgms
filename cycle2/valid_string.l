%{
#include <stdio.h>
int flag = 1;
%}

%%

[pP][rR][aA][nN]    { flag = 0; }
\n                  { return 0; }
.                   ;

%%

int yywrap()
{
    return 1;
}

int main()
{
    printf("Enter string: ");
    yylex();

    if (flag == 1)
        printf("ACCEPTED: String does not contain 'pran' as a substring.\n");
    else
        printf("REJECTED: String contains 'pran' as a substring.\n");

    return 0;
}
