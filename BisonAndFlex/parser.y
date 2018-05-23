%defines

%{
	#pragma warning(disable: 4996)

	#include <iostream>
	#include <stdio.h>
	#include <stdlib.h>
	#include <math.h>

	extern int yylex();
	extern void yyerror(char const* msg);
	extern double factorial(int n);
%}

%union
{
	double my_dbl;
}

%token<my_dbl> NUMBER
%token<my_dbl> PI
%token<my_dbl> PLUS MINUS TIMES DIVIDE
%token<my_dbl> POWER MOD FACTORIAL
%token<my_dbl> LOG
%token<my_dbl> LEFT RIGHT
%token<my_dbl> COMMA END
%token<my_dbl> NEG

%type<my_dbl> Program
%type<my_dbl> Line
%type<my_dbl> Expression
%type<my_dbl> Constant
%type<my_dbl> Function

%left PLUS MINUS TIMES DIVIDE
%right POWER

%start Program

%%
Program:

	| Program Line
	;

Line:
	END
	| Expression END { printf("Result: %f\n", $1); }
	;

Expression:
	NUMBER { $$ = $1; }
	| Constant
	| Function
	| Expression PLUS Expression { $$ = $1 + $3; }
	| Expression MINUS Expression { $$ = $1 - $3; }
	| Expression TIMES Expression { $$ = $1 * $3; }
	| Expression DIVIDE Expression {
		if($3 == 0) {
			yyerror("Cannot devide by 0.");
		} else {
			$$ = $1 / $3;
		}
	}
	| Expression MOD Expression {
		if( $1 != static_cast<int>($1) || $3 != static_cast<int>($3) ){
			yyerror("Mod an interger.");
		}
		if ($3 == 0) {
			yyerror("Cannot mod by 0.");
		}
		$$ = static_cast<int>($1) % static_cast<int>($3);
	}
	| MINUS Expression %prec NEG { $$ = -$2; }
	| Expression POWER Expression { $$ = pow($1, $3); }
	| LEFT Expression RIGHT { $$ = $2; }
	;

Constant:
	PI { $$ = 3.14159265; }
	;

Function:
	LOG LEFT Expression COMMA Expression RIGHT {
		if ($3 <= 0 || $3 == 1) {
			yyerror("Base number of log must be positive and cannot be 1.");
		} else {
			$$ = log($5) / log($3);
		}
	}
	| Expression FACTORIAL {
		if( $1 != static_cast<int>($1) ){
			yyerror("Must mod by an interger.");
		} else{
			$$ = factorial(static_cast<int>($1));
		}
	}
	;

%%

extern char* yytext;
extern int yylineno;

double factorial(int n){
	if (n > 1)
		return n * factorial(n-1);
	else
		return 1;
}

void yyerror(char const * msg)
{
	printf("%s on line %d - %s\n", msg, yylineno, yytext);
}