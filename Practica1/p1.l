%{
unsigned charCount = 0, wordCount = 0;
unsigned upperWord = 0, lowerWord = 0, phraseCount =0;
%}
word [^ \t\n]+
upper [A-ZÑ]+
lower [a-zñ]+
delim [ \t\n]
ws {delim}+
%%
{upper}"." {upperWord++; wordCount++; charCount+=yyleng; phraseCount++;}
{lower}"." {lowerWord++; wordCount++; charCount+=yyleng; phraseCount++;}
{upper} {upperWord++; wordCount++; charCount+=yyleng;}
{lower} {lowerWord++; wordCount++; charCount+=yyleng;}
{word}"."  {wordCount++; charCount+=yyleng; phraseCount++;}
{word}  {wordCount++; charCount+=yyleng;}
{ws} {}


%%
int main()
{
    yylex();
    printf("CARACTERES PALABRAS MAYUSCULAS MINUSCULAS FRASES \n");
	printf("%7.0d %8.0d %8.0d %10.0d %8.0d \n",charCount,  wordCount, upperWord,lowerWord,phraseCount);
    return 0;
}