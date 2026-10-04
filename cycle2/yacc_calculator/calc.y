%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(char *s);
%}

%union {
    double dval;
}

%token <dval> NUMBER
%type <dval> EXPR

%left '+' '-'
%left '*' '/'
%right UMINUS

%%

stmt: EXPR '\n' { printf("Result = %g\n", $1); exit(0); }
    ;

EXPR: EXPR '+' EXPR { $$ = $1 + $3; }
    | EXPR '-' EXPR { $$ = $1 - $3; }
    | EXPR '*' EXPR { $$ = $1 * $3; }
    | EXPR '/' EXPR { 
                        if ($3 == 0) {
                            printf("Error: Division by zero\n");
                            exit(1);
                        }
                        $$ = $1 / $3; 
                    }
    | '(' EXPR ')'   { $$ = $2; }
    | '-' EXPR %prec UMINUS { $$ = -$2; }
    | NUMBER        { $$ = $1; }
    ;

%%

void yyerror(char *s)
{
    printf("Invalid Expression\n");
    exit(1);
}

int main()
{
    printf("Enter an arithmetic expression: ");
    yyparse();
    return 0;
}
