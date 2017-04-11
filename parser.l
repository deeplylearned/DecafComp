digit	[0-9] 
letter	[A-Za-z]

%{
	#include<math.h>
	int lineCount = 1;
	int colCount = 1;
	union YYSTYPE{
	char *sval;
	int ival;
	double fval;
	}yylval;
	struct yyltype yylloc;
    	#include<string.h>
	#include"location.h"
	//#include"errors.h"
%}

%%

\n { lineCount++;colCount =1;}
[\t] {colCount += 8; }
[ ] {colCount++;}

"//".* {
	/*lineCount++;*/colCount=1;
	//Ignore a comment
	printf("%s\t:This is a single line comment.\n",yytext);
}

[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/] { 
	/* DO NOTHING */ 	
	printf("%s\t:This is a multi line comment.\n",yytext);
}
[/][*] {
	fprintf(stderr,"\nUnterminated comment.%d\n",yylloc.first_line);
}

void|int|double|bool|string|class|interface|null|this|extends|implements|for|while|if|else|return|break|new|NewArray|Print|ReadInteger|ReadLine {
		printf( "%s\t\t:KEYWORD\t", yytext );
		yylloc.first_line = lineCount;
		yylloc.last_line = lineCount;
		yylloc.first_column = colCount;
		colCount += yyleng;		
		yylloc.last_column = colCount;
		printf("Pos: %d %d %d\n",yylloc.last_line,yylloc.first_column,yylloc.last_column);		
		}




{letter}({letter}|{digit})* 	{
	
	yylloc.first_line = lineCount;
	yylloc.last_line = lineCount;
	yylloc.first_column = colCount;
	colCount += yyleng;		
	yylloc.last_column = colCount;
	yylval.sval = strdup(yytext);
	printf("%s\t\t:IDENTIFIER\t", yylval.sval);
	printf("Pos: %d %d %d\n",yylloc.last_line,yylloc.first_column,yylloc.last_column);
}

\-?{digit}+"."({digit})* {
	yylloc.first_line = lineCount;
	yylloc.last_line = lineCount;
	yylloc.first_column = colCount;
	colCount += yyleng;		
	yylloc.last_column = colCount;	
	yylval.fval = atof(yytext);
	printf("%lf\t\t:FLOATING POINT\t", yylval.fval);
	printf("Pos: %d %d %d\n",yylloc.last_line,yylloc.first_column,yylloc.last_column);
	}

\-?{digit}* {
	yylloc.first_line = lineCount;
	yylloc.last_line = lineCount;
	yylloc.first_column = colCount;
	colCount += yyleng;		
	yylloc.last_column = colCount;	
	yylval.ival = atoi(yytext);
	printf("%d\t\t:INTEGER\t", yylval.ival);
	printf("Pos: %d %d %d\n",yylloc.last_line,yylloc.first_column,yylloc.last_column);
	}

\"[^"\n]*["\n] {	
	yylloc.first_line = lineCount;
	yylloc.last_line = lineCount;
	yylloc.first_column = colCount;
	colCount += yyleng;		
	yylloc.last_column = colCount;
        yylval.sval = strdup(yytext+1);
        if (yylval.sval[yyleng-2] != '"'){
            fprintf(stderr,"\nimproperly terminated string at line %d\n", yylloc.first_line);
	    //OutputError(yylloc,"improperly terminated string");
	}
        else{
            yylval.sval[yyleng-2] = 0;
            printf("%s\t\t:STRING LITERAL\t", yylval.sval);
	    printf("Pos: %d %d %d\n",yylloc.last_line,yylloc.first_column,yylloc.last_column);
        }
    }


"<="|">="|"=="|"!="|"<"|">" {
	yylloc.first_line = lineCount;
	yylloc.last_line = lineCount;
	yylloc.first_column = colCount;
	colCount += yyleng;		
	yylloc.last_column = colCount;
	printf("%s\t\t :RELOP\t",yytext);
	printf("Pos: %d %d %d\n",yylloc.last_line,yylloc.first_column,yylloc.last_column);
}

"+"|"-"|"*"|"/"|"%"|"=" { 
	yylloc.first_line = lineCount;
	yylloc.last_line = lineCount;
	yylloc.first_column = colCount;
	colCount += yyleng;		
	yylloc.last_column = colCount;
	printf("%s\t\t:ARITHEMATIC OP\t", yytext);
	printf("Pos: %d %d %d\n",yylloc.last_line,yylloc.first_column,yylloc.last_column);
}

"!"|";"|","|"."|"["|"]"|"("|")"|"{"|"}" { 
	yylloc.first_line = lineCount;
	yylloc.last_line = lineCount;
	yylloc.first_column = colCount;
	colCount += yyleng;		
	yylloc.last_column = colCount;
	printf("%s\t\t:OTHER SYMBOL\t", yytext);
	printf("Pos: %d %d %d\n",yylloc.last_line,yylloc.first_column,yylloc.last_column);
}

"&&"|"\|\|" { 
	yylloc.first_line = lineCount;
	yylloc.last_line = lineCount;
	yylloc.first_column = colCount;
	colCount += yyleng;		
	yylloc.last_column = colCount;
	printf("%s\t\t:LOGICAL OPERATOR\t", yytext);
	printf("Pos: %d %d %d\n",yylloc.last_line,yylloc.first_column,yylloc.last_column);
}
%%

void main(){
	yylex();
}
