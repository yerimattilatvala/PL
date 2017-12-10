%{
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

int yylineno;
int a=0;
int s=0;
int n=0;
char* asignatura;
char* curso;

typedef struct {
		int linea;
		char* nif;
		char* nombre;
		float nota;
		}alum;

struct err {
	int linea;
	char* err;
	};


alum aprobados[100];
alum suspensos[100];
struct err errores[100];


void yyerror (char const *);
void addAlumno (bool ,int ,char* , char* , double);
%}
%error-verbose
%union{
	float valFloat;
	char* valString;	
}


%token <valString> NIF
%token <valString> ASIGNATURA
%token <valString> CURSO
%token <valString> NOMBRE
%token <valFloat> NOTA
%token NEWLINE
%token endfile
%type <valString> lista_alumnos



%start S
%%

S: ASIGNATURA CURSO NEWLINE list{
	asignatura=$1;
	curso=$2;
}
;
list : lista_alumnos {}
;

lista_alumnos: lista_alumnos alumno
	| alumno {}
;

alumno: NIF NOMBRE NOTA end {
			if(($3>=0.00) && ($3<=10.0)){	
				if($3>=5.0){
					addAlumno(true,yylineno-1,$1,$2,$3);
				}else{
					addAlumno(false,yylineno-1,$1,$2,$3);
				}
			}else { errores[n].linea=yylineno-1;
					yyerror("NOTA incorrecta");
					n=n+1;}
		}
	|NIF NOMBRE errors end {errores[n].linea=yylineno-1;
						yyerror("NOTA incorrecta");
						n=n+1;}
	|NIF errors NOTA end {errores[n].linea=yylineno-1;
						yyerror("NOMBRE incorrecto");
						n=n+1;}
	|errors NOMBRE NOTA end {errores[n].linea=yylineno-1;
						yyerror("NIF incorrecto");
						n=n+1;}
	|errors NOTA end {errores[n].linea=yylineno-1;
						yyerror("NIF y NOMBRE incorrectos");
						n=n+1;}
	|NIF errors end {errores[n].linea=yylineno-1;
						yyerror("NOMBRE y NOTA incorrectos");
						n=n+1;}
	|errors NOMBRE errors end {errores[n].linea=yylineno-1;
						yyerror("NIF y NOTA incorrectos");
						n=n+1;}
	|errors end {errores[n].linea=yylineno-1;
						yyerror("TODO MAL");
						n=n+1;}
;


errors: error
	|error errors;


end: NEWLINE
	| NEWLINE end
	| endfile;

%%

void yyerror(char const *s){
	errores[n].err=strdup(s);
}

void addAlumno(bool aprobado,int linea,char* nif, char* nombre, double nota){
	if (aprobado){
		aprobados[a].linea=linea;
		aprobados[a].nif=nif;
		aprobados[a].nombre=nombre;
		aprobados[a].nota=nota;
		a=a+1;
	}
	else{
		suspensos[s].linea=linea;
		suspensos[s].nif=nif;
		suspensos[s].nombre=nombre;
		suspensos[s].nota=nota;
		s=s+1;
	}
}
int i;
void printArrays(){
	printf("+ Alumnos aprobados:\n");
	for (i=0;i<a;i++){
		printf("Linea %i: %s;%s;%2.2f\n",aprobados[i].linea,aprobados[i].nif,aprobados[i].nombre,aprobados[i].nota);
	}
	printf("+ Alumnos suspensos:\n");
	for (i=0;i<s;i++){
		printf("Linea %i: %s;%s\n",suspensos[i].linea,suspensos[i].nif,suspensos[i].nombre);
	}
	printf("+ Errores:\n");
	for (i=0;i<n;i++){
		printf("Linea %i: %s\n",errores[i].linea,errores[i].err);
	}
}


int main() {
	yyparse();
	printf("- Asignatura: %s\n",asignatura);
	printf("- Curso: %s\n",curso);
	printArrays();
	return 0;
}


