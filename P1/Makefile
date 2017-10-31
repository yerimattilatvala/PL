FUENTE = p1

all: compile run

compile: 
	flex $(FUENTE).l
	gcc -o $(FUENTE) lex.yy.c -lfl

run:
	./$(FUENTE) 