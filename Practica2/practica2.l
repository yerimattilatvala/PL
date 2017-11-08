%{
#include <stdlib.h>
#include "practica2.tab.h"
unsigned numLinea = 0;
%}
nif [0-9]{8}"-"[A-Z]{1} 
data [0-9]{4}"/"[0-9]{4} 
delim [ \t]
ws {delim}*
word [A-ZÑa-zñ]+{ws}
nota [0-9]+"."[0-9]+
%%
{nota} {yylval.valFloat = atof(yytext); return NOTA;}
Curso{ws}{data} {yylval.valStr = yytext; return CURSO;}
{nif} {yylval.valStr = yytext; return NIF;}
{word}+"-" {yylval.valStr = yytext; return ASIGNATURA;}
{word}+","{word}+ {yylval.valStr = yytext; return NOMBRE_COMPLETO;}
\n {}
{ws} {}
%%

