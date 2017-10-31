%{
unsigned dniCount = 0, jlCount = 1, c=0, asignature = 0;
unsigned name = 0, subname = 0;
%}
nif [0-9]{8}"-"[A-ZÑ]
data [0-9]{4}"/"[0-9]{4}
delim [ \t]
ws {delim}*
word [A-ZÑa-zñ]+{ws}
%%
Curso{ws}{data} {c++;}
{nif} {dniCount++;}
{word}\n {name++;jlCount;;}
{word}+"-" {asignature++;}
{word}+"," {subname++;jlCount;;}
\n {jlCount++;}
{ws}
%%
int main()
{
    yylex();
    printf("%d,%d,%d,%d,%d,%d\n",dniCount,jlCount,c,asignature,name,subname);
    return 0;
}
