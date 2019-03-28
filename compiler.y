%{
	#include <stdio.h>
	#include <stdlib.h>
	int yylex();
	int yyerror();
	extern FILE *yyin;
%}
   
%token TRUE FALSE STRING INTEGER OB CB NOT EQ LET LT COMP DIV

%% 
stmt : program NL; #let's stick to using the augmented grammar
features: feature; features 
		|
		;
classes: class; classes1
		;
classes1: class; classes1
		|
		;
formals: ,formal formals
		|
		;
exprs: ,expr exprs
		|
		;
program: classes
		;
class: class TYPE [inherits TYPE] {features}
		;
feature: ID ([formal formals]) : TYPE {expr}
		| ID : TYPE [<- expr]
		;
formal: ID:TYPE
		;
expr: ID <- expr
		| expr [@TYPE].ID ([expr exprs])
		| ID ([expr exprs])
		;

expressplus: expr SCO expressplus | ;

express: COMMA ID COL TYPE OSB ASSIGN expr CSB express|
	;


cases: ID COL TYPE TYPEOF expr SCO cases1;

cases1: ID COL TYPE TYPEOF expr SCO cases1 | ;

expr : TRUE | FALSE | STRING | INTEGER | ID | OB expr CB |NOT expr | expr EQ | expr LET expr | expr LT expr | COMP expr | expr DIV expr | expr MUL expr | expr SUB expr | expr ADD expr | ISVOID expr | NEW TYPE | CASE expr OF OSB cases ESAC| LET ID COL TYPE OSB ASSIGN expr CSB express in expr| OCB expressplus CCB| WHILE expr LOOP expr POOL| IF expr THEN expr ELSE expr FI;
%%

int yyerror(char *msg)
{
	printf("invalid expression\n");
	return 1; 
}

void main()
{
	printf("Enter the expression\n");
	yyin=fopen("q2in.txt", "r");
	do 
	{
	 if(yyparse())
	 {
	  printf("\n Failure");
	  exit(0);
	 }
	} while (!feof(yyin));
	printf("Success");
}