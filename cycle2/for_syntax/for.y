%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(char *s);
typedef struct yy_buffer_state *YY_BUFFER_STATE;
extern YY_BUFFER_STATE yy_scan_string(const char *);
extern void yy_delete_buffer(YY_BUFFER_STATE);
%}

%token FOR ID NUM REL_OP INC_OP

%left '+' '-'
%left '*' '/'
%right UMINUS

%%

stmt: FOR '(' INIT ';' COND ';' INCR ')' BODY { printf("Valid For Loop Syntax\n"); exit(0); }
    ;

INIT: ID '=' EXPR
    | /* epsilon */
    ;

COND: EXPR REL_OP EXPR
    | EXPR
    | /* epsilon */
    ;

INCR: ID '=' EXPR
    | ID INC_OP
    | INC_OP ID
    | /* epsilon */
    ;

EXPR: EXPR '+' EXPR
    | EXPR '-' EXPR
    | EXPR '*' EXPR
    | EXPR '/' EXPR
    | '-' EXPR %prec UMINUS
    | '(' EXPR ')'
    | ID
    | NUM
    ;

BODY: '{' STMT_LIST '}'
    | STMT
    | ';'
    ;

STMT: ID '=' EXPR ';'
    | ID INC_OP ';'
    ;

STMT_LIST: STMT_LIST STMT
         | /* epsilon */
         ;

%%

void yyerror(char *s)
{
    printf("Invalid For Loop Syntax\n");
    exit(1);
}

int main()
{
    char input[256];

    printf("Enter a FOR loop statement: ");
    if (fgets(input, sizeof(input), stdin) == NULL)
        return 1;

    YY_BUFFER_STATE buffer = yy_scan_string(input);
    yyparse();
    yy_delete_buffer(buffer);
    return 0;
}
