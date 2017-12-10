%option yylineno

%{
#include <stdlib.h>
#include <string.h>
#include "p2.tab.h"
int fields=0;
%}

nif [0-9]{8}"-"[A-Z]{1}
nota [0-9]{1,2}"."[0-9]{1,2}
curso [0-9]{4}"/"[0-9]{4}
delim [ \t]
ws {delim}+
word [A-ZÑÁÉÍÓÚa-záéíóúñ ]+

%%
"Identificador"{ws}"Alumno"{ws}"Nota"\n ;
{word}*{word}+","{word}*{word}+ {yylval.valString=strdup(yytext); return NOMBRE;}
{nota} {yylval.valFloat = atof(yytext); return NOTA;}
{nif} {yylval.valString = strdup(yytext); return NIF;}
{curso} {yylval.valString = strdup(yytext); return CURSO;}
{word}+/"-" {yylval.valString= strdup(yytext); return ASIGNATURA;}
. ;
\n {return NEWLINE;}
<<EOF>> {return 0;return endfile;}
%%
