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
Curso{ws}{data}{ws} {yylval.valStr = yytext; return CURSO;}
{nif} {yylval.valStr = strdup(yytext); return NIF;}
{word}+ { return CAMPOS;}
{word}+"-" {yylval.valStr = strdup(yytext); return ASIGNATURA;}
{word}+","{ws}{word} {yylval.valStr = strdup(yytext); return NOMBRE_COMPLETO;}
{ws} {}
\n {}
%%

