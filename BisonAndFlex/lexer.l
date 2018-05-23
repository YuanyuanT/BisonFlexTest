%option yylineno noyywrap

%top{
	
	#pragma warning(disable: 4996)

}

%{
	#include <stdlib.h>
	#include "parser.hpp"
	
	extern int yyparse();
%}

white		[ \t]+
integer		[0-9]+
exponent	[eE][+-]?{integer}
real		{integer}("."{integer})?{exponent}?

%%
{white}		{}
{real}		{
	yylval.my_dbl = atof(yytext);
	return NUMBER;
}

"+"				{ return PLUS; }
"-"				{ return MINUS; }
"*"				{ return TIMES; }
"/"				{ return DIVIDE; }
"^"				{ return POWER; }
"%"				{ return MOD; }
"!"				{ return FACTORIAL; }
"("				{ return LEFT; }
")"				{ return RIGHT; }
","				{ return COMMA; }
"log"			{ return LOG; }
("pi")|("PI")	{ return PI; }
"\n"			{ return END; }		
