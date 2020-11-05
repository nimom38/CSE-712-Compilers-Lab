%{
  #include<stdio.h>
  #ifdef YYDEBUG
    yydebug = 1;
  #endif
  void yyerror (char const *s);
  int yywrap();
  int yylex(void);
  void set_input(const char* input);
%}
%union {
  char *s;
}
%token <s>  NUMBER
%token <s> VARIABLE
%token <s> OPERATOR
%token <s>  KEYWORD
%token  EXCLAMATION
%token  COMMA
%token  EQUALS
%token  START_P
%token  END_P
%token  START_C
%token  END_C
%token  RETURN
%%
PROGRAM         : STATEMENTS                        {
                                                        printf("Tiny Program\n");
                                                    }                                         

STATEMENTS      : STATEMENT                         {
                                                        printf("Statement\n");
                                                    }                                 
                | STATEMENT STATEMENTS              {
                                                        printf("Statements\n");
                                                    }
                ;                                   

STATEMENT       : VAR_DECLARE EXCLAMATION           {
                                                        printf("Var Declare Statement\n");
                                                    }
                | FUNC_DECLARE                      {
                                                        printf("Function Declare\n");
                                                    }
                | FUNC_CALL EXCLAMATION   
                                                    {
                                                        printf("Just a Function Call as a Statement\n");
                                                    }
                | VAR_ASSIGN EXCLAMATION            {
                                                        printf("Variable Assignment Statement\n");
                                                    }
                ;

VAR_ASSIGN      : VARIABLE EQUALS VALUE             {
                                                        printf("Var Assignment\n");
                                                    }

VAR_DECLARE     : KEYWORD VARIABLE                  {
                                                        printf("Variable Declare Without Value\n");
                                                    }                        
                | KEYWORD VARIABLE EQUALS VALUE     {
                                                        printf("Variable Declare With Value\n");
                                                    }
                ;                          
                                           
FUNC_DECLARE    : KEYWORD VARIABLE START_P PARAMETERS END_P BLOCK   {
                                                                        printf("Func Declare Without Param\n");
                                                                    }
                | KEYWORD VARIABLE START_P END_P BLOCK              {
                                                                        printf("Func Declare Without Param\n");
                                                                    }



PARAMETERS      : KEYWORD VARIABLE                                  {
                                                                        printf("Param\n");
                                                                    }                    
                | KEYWORD VARIABLE COMMA PARAMETERS                 {
                                                                        printf("More Params\n");
                                                                    }    

BLOCK           : START_C STATEMENTS END_C                          {
                                                                        printf("Block With Statements\n");
                                                                    }
                | START_C STATEMENTS RETURN VALUE EXCLAMATION END_C
                                                                    {
                                                                        printf("Block With Return Value\n");
                                                                    }
                | START_C END_C                                     {
                                                                        printf("Empty Block\n");
                                                                    }


VALUE           : VARIABLE
                            {
                                printf("Value from Variable\n");
                            }                                       
                | NUMBER
                            {
                                printf("Value from Number\n");
                            }
                | VARIABLE OPERATOR VARIABLE
                            {
                                printf("Value from Variable Variable Operation\n");
                            }                           
                | VARIABLE OPERATOR NUMBER    
                            {
                                printf("Value from Variable Number Operation\n");
                            }                                                         
                | NUMBER OPERATOR VARIABLE  
                            {
                                printf("Value from Number Variable Operation\n");
                            }                                                           
                | NUMBER OPERATOR NUMBER       
                            {
                                printf("Value from Number Number Operation\n");
                            }                                                        
                | FUNC_CALL      
                            {
                                printf("Value from Function Call\n");
                            }                               
                ;


FUNC_CALL       : VARIABLE START_P END_P     
                            {
                                printf("Just Another Function Call\n");
                            }                              
                | VARIABLE START_P PARAM_VALUES END_P
                            {
                                printf("Function Call With Params\n");
                            }     



PARAM_VALUES    : VALUE    
                            {
                                printf("Param Passed\n");
                            }                                    
                | VALUE COMMA PARAM_VALUES       
                            {
                                printf("More Param Passed\n");
                            }                      

%%


int main() {
  char buffer[BUFSIZ];
  for(;;) {
    char* input = fgets(buffer, sizeof buffer, stdin);
    if (buffer == NULL)  break;
      set_input(input);
      yyparse();
      printf("Parsing completed!!!!!!!!\n");
  }
  return 0;
}
int yywrap() {
  return 1;
}
void yyerror (char const *s) {
  printf("Error :\n");
  fprintf (stderr, "%s\n", s);
}
