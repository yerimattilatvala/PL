%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>
void yyerror (char const *);
int yylex();
char str2[128]; // para copiar la asignatura sin el guion
char str3[10]; // para chequear el dni
int linea = 1;
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
%token <valStr> CAMPOS
%type <valStr>  fichero cabecera lista_alumnos alumno 
%error-verbose
%start S
%%
S : fichero {printList(aprobados,suspensos,errores);}
	;
fichero : cabecera identificadores lista_alumnos
	;
cabecera : ASIGNATURA CURSO {strncpy(str2,$1,(strlen($1)-1));
							printf("- Asignatura : %s\n",str2);
							printf("- %s \n",$2);
							linea++;
							} 			 
	;
identificadores : CAMPOS	{
							linea++;
							}
	;
lista_alumnos : lista_alumnos alumno
	| alumno
	;
alumno : NIF NOMBRE_COMPLETO NOTA{
		strncpy(str3,$1,(strlen($1)-2));
		char *endptr;
		strtol(str3, &endptr, 10);
		if (*endptr == '\0'){
			struct alumno alumno = crearAlumno(linea,$1,$2,$3);
			if ($3 >= 5 && $3 <= 10) {
				insertarAlumno(alumno,aprobados,posAprobado);
				posAprobado++;
			}else if ($3 >= 0 && $3 < 5){
				insertarAlumno(alumno,suspensos,posSuspenso);
				posSuspenso++;
				
			} else{
				struct error e = crearError(linea,"Nota Incorrecta");
				insertarError(e,errores,posError);
				posError++;
			}
		} else{
				struct error e = crearError(linea,"NIF Incorrecto");
				insertarError(e,errores,posError);
				posError++;
		}
		linea++;
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
