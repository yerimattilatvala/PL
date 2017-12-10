FUENTE = p1
PRUEBA = prueba.txt

all: compile run

compile: 
	flex $(FUENTE).l
	gcc -o $(FUENTE) lex.yy.c -lfl

run:
	./$(FUENTE) < $(PRUEBA)
