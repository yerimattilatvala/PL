%{
#include <stdio.h>
//función para imprimir listas
void printList ();
void yyerror (char const *);
int yylex();
%}
%union{
    float valFloat;
    int valInt;
    char * valStr;
}
%token <valFloat> NOTA
%token <valInt> LINEA
%token <valStr> NOMBRE_COMPLETO NIF
%token <valStr> ASIGNATURA CURSO
%type <valStr>  fichero cabecera lista_alumnos alumno 
%error-verbose
%start S
%%
S : fichero {printList();}
	;
fichero : cabecera lista_alumnos
	;
cabecera : ASIGNATURA CURSO {printf("- Asignatura : %s \n",$1);
							 printf("- %s \n",$2);}
	;
lista_alumnos : lista_alumnos alumno
	| alumno
	;
alumno : NIF NOTA{
		printf("%s; ",$1);
		printf("%f; ",$2);
		}
	;
%%
int main(int argc, char *argv[]) {
extern FILE *yyin;

	switch (argc) {
		case 1:	yyin=stdin;
			yyparse();
			break;
		case 2: yyin = fopen(argv[1], "r");
			if (yyin == NULL) {
				printf("ERROR: No se ha podido abrir el fichero.\n");
			}
			else {
				yyparse();
				fclose(yyin);
			}
			break;
		default: printf("ERROR: Demasiados argumentos.\nSintaxis: %s [fichero_entrada]\n\n", argv[0]);
	}
	return 0;
}
void yyerror (char const *message) { fprintf (stderr, "%s\n", message);}
void printList () {printf("AQUI LISTAS \n");}

