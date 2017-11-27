%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>
void yyerror (char const *);
int yylex();
extern int yylineno;
struct alumno
{
	int lineaAlumno;
	char *nif;
	char *nombre;
	float nota;
};
int posAprobado = 0;
int posSuspenso = 0;
struct alumno aprobados[128];
struct alumno suspensos[128];
struct alumno crearAlumno(int linea, char *nif, char *nombre, float nota);
void insertarAlumno(struct alumno alumno, struct alumno *lista, int posicion);
struct error{
	int lineaError;
	char *error;
};
int posError = 0;
struct error errores[128];
struct error crearError(int linea,char*error);
void insertarError(struct error e,struct error *listaError,int posicion);
//función para imprimir listas
void printList (struct alumno *listaAprobados,struct alumno *listaSuspensos, struct error *errores);
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
S : fichero {printList(aprobados,suspensos,errores);}
	;
fichero : cabecera  lista_alumnos
	;
cabecera : ASIGNATURA CURSO {
							printf("- Asignatura : %s\n",$1);
							printf("- Curso %s \n",$2);
							} 			 
	;
lista_alumnos : lista_alumnos alumno
	| alumno
	;
alumno : NIF NOMBRE_COMPLETO NOTA{
				struct alumno alumno = crearAlumno(yylineno,$1,$2,$3);
				if ($3 >= 5 && $3 <= 10) {
					insertarAlumno(alumno,aprobados,posAprobado);
					posAprobado++;
				}else if ($3 >= 0 && $3 < 5){
					insertarAlumno(alumno,suspensos,posSuspenso);
					posSuspenso++;
					
				} else{
					struct error e = crearError(yylineno,"Nota Incorrecta");
					insertarError(e,errores,posError);
					posError++;
				}
				}
		| error NOMBRE_COMPLETO NOTA {
			struct error e = crearError(yylineno,"NIF Incorrecto");
			insertarError(e,errores,posError);
			posError++;
		}
		| NIF error NOTA {
			struct error e = crearError(yylineno,"Nombre Incorrecto");
			insertarError(e,errores,posError);
			posError++;
		}
		| NIF NOMBRE_COMPLETO error {
			struct error e = crearError(yylineno,"Nota Incorrecta");
			insertarError(e,errores,posError);
			posError++;
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
void yyerror (char const *message) { /*fprintf (stderr, "%s\n", message); printf("%d\n",yylineno);*/}

struct alumno crearAlumno(int linea,char *nif, char *nombre, float nota) {
	struct alumno a;
	a.lineaAlumno = linea;
	a.nif = nif;
	a.nombre = nombre;
	a.nota = nota;
	return a;
}

void insertarAlumno(struct alumno alumno, struct alumno *lista, int posicion) {
	lista[posicion] = alumno;
}

void insertarError(struct error e,struct error *listaError,int posicion) {
	listaError[posicion] = e;
}

void printList (struct alumno *listaAprobados,struct alumno *listaSuspensos, struct error *errores) {
	int i = 0;
	printf("+ Alumnos aprobados: \n");
	for(i = 0; i < posAprobado; i++){
		printf("Linea %d: %s; %s; %.2f\n",listaAprobados[i].lineaAlumno,listaAprobados[i].nif,listaAprobados[i].nombre,listaAprobados[i].nota);
	}
	printf("+ Alumnos suspensos: \n");
	for(i = 0; i < posSuspenso; i++){
		printf("Linea %d: %s; %s; %.2f\n",listaSuspensos[i].lineaAlumno,listaSuspensos[i].nif,listaSuspensos[i].nombre,listaSuspensos[i].nota);
	}
	printf("+ Errores: \n");
	for(i = 0; i < posError; i++){
		printf("Linea %d: %s\n",errores[i].lineaError,errores[i].error);
	}
}

struct error crearError(int linea,char*error) {
	struct error e;
	e.lineaError = linea;
	e.error = error;
	return e;
}
