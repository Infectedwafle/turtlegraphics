%{
	#include <stdio.h>
	#include "zoomjoystrong.h"
	int yylex();
	void yyerror(char *s);
%}

%union {
	int iVal;
	char* sVal;
	float fVal;
}
%token <iVal> INT
%token <fVal> FLOAT
%token <sVal> END
%token <sVal> END_STATEMENT
%token <sVal> POINT
%token <sVal> CIRCLE
%token <sVal> LINE
%token <sVal> RECTANGLE
%token <sVal> SET_COLOR
%token <sVal> ERROR

// This gives better error messages
%define parse.error verbose

%%
program: statement_list END END_STATEMENT		{
								finish();
							}
statement_list: statement
		| statement statement_list

statement: POINT INT INT END_STATEMENT 			{			
								// This makes sure that the point will draw on the screen
								if($2 >= 0 && $2 <= WIDTH && $3 >= 0 && $3 <= HEIGHT)
								{
									point($2, $3);
								} else {
									printf("point will not be drawn it is off the screen");
								}
							}
	|  LINE INT INT INT INT END_STATEMENT		{
								// This makes sure that the line will draw withing the screen
								if($2 >= 0 && $2 <= WIDTH && $3 >= 0 && $3 <= HEIGHT &&
								   $4 >= 0 && $4 <= WIDTH && $5 >= 0 && $5 <= HEIGHT)
								{
									line($2, $3, $4, $5);
								} else
								{
									printf("line will not be drawn it will go off screen");
								}
							}
	|  CIRCLE INT INT INT END_STATEMENT		{	
								// This makes sure that at least some part of the circle draws on the screen
								if($2 > (-1 * $4) && $2 < ( WIDTH + $4) && $3 > (-1 * $4) && $3  < (HEIGHT + $4)) {
									circle($2, $3, $4);
								} else
								{
									printf("circle will not be drawn off completely off screen");
								}	
							}
	|  RECTANGLE INT INT INT INT END_STATEMENT	{
								// This makes sure that the rectangle is drawn on the screen
								if($2 >= 0 && $2 <= WIDTH && $3 >= 0 && $3 <= HEIGHT &&
								   $4 >= 0 && $4 <= WIDTH && $5 >= 0 && $5 <= HEIGHT)
								{
									rectangle($2, $3, $4, $5);
								} else
								{
									printf("line will not be drawn it will go off screen");
								}
							}
	|  SET_COLOR INT INT INT END_STATEMENT		{	
								// This makes sure that all color values are valid before changing the value
								if($2 >= 0 && $2 < 256 && $3 >= 0 && $3 < 256 && $4 >= 0 && $4 < 256)
								{
									set_color($2, $3, $4);
								} else
								{
									printf("color will not change invalid color value");
								}
							}
	|  ERROR					{
								// Give the user an error for using bad input. Then quit the program
								yyerror("You used an invalid token. Program will exit");
								finish();
								return -1;
							}
%%

int main(int argc, char *argv[]) { 
  setup(); 
  return( yyparse());
}

void yyerror(char* s)
{
	fprintf(stderr, "%s\n", s);
}

int yywrap()
{
	return(1);
}


