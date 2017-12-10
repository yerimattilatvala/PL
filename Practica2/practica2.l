%option yylineno

%{
#include <stdlib.h>
#include "practica2.tab.h"
%}
nif [0-9]{8}"-"[A-Z]{1}
nota [0-9]{1,2}"."[0-9]{1,2}
data [0-9]{4}"/"[0-9]{4}
delim [ \t]
ws {delim}+
word [A-ZÑÁÉÍÓÚa-záéíóúñ ]+
%%
"Identificador"{ws}"Alumno"{ws}"Nota"\n ;
{word}*{word}+","{word}*{word}+ {yylval.valStr = strdup(yytext); return NOMBRE_COMPLETO;}
{nota} {yylval.valFloat = atof(yytext); return NOTA;}
{data} {yylval.valStr = yytext; return CURSO;}
{nif} {yylval.valStr = strdup(yytext); return NIF;}
{word}+[0-9]?{ws}?/"-" {yylval.valStr = strdup(yytext); return ASIGNATURA;}
. ;
\n {return LINEA;}
<<EOF>> {return FIN;}
%%

