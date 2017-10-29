%{
	#include <stdio.h>
	#include "zoomjoystrong.tab.h"
	int fileno(FILE *stream);
%}
%option no yywrap

%%
[0-9]+			{ yylval.iVal=atoi(yytext); return(INT); }
[0-9]*\.[0-9]+		{ yylval.fVal=atoi(yytext); return(FLOAT); }
(?i:end)		{ yylval.sVal=yytext; return(END); }
[;]			{ yylval.sVal=yytext; return(END_STATEMENT); }
(?i:point)		{ yylval.sVal=yytext; return(POINT); }
(?i:circle)		{ yylval.sVal=yytext; return(CIRCLE); }
(?i:line)		{ yylval.sVal=yytext; return(LINE); }
(?i:rectangle)		{ yylval.sVal=yytext; return(RECTANGLE); }
(?i:set_color)		{ yylval.sVal=yytext; return(SET_COLOR); }
[[:space:]\n\t\r]+	;
.			{ yylval.sVal=yytext; return(ERROR); }
%%
