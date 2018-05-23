#include "parser.hpp"
#include <stdio.h>
#include <iostream>
#include <math.h>
#include <algorithm>

extern FILE*  yyin;
extern int yyparse();

static bool read_file(const char* name) {
	yyin = fopen(name, "r");
	if (yyin == NULL) {
		std::cerr << name << ": " << strerror(errno)
			<< std::endl;
		return false;
	}
	else {
		bool success = ( yyparse() == 0);
		fclose(yyin);
		return success;
	}
}

int main()
{
	return read_file("test.txt");
}

