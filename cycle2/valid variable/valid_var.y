%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(char *s);
%}

%token LETTER DIGIT

%%

stmt: VARIABLE '\n' { printf("Valid Identifier\n"); exit(0); }
    ;

VARIABLE: LETTER REST
        ;

REST: REST LETTER
    | REST DIGIT
    | /* epsilon */
    ;

%%

void yyerror(char *s)
{
    printf("Invalid Identifier\n");
    exit(0);
}

int main()
{
    printf("Enter a variable name: ");
    yyparse();
    return 0;
}
