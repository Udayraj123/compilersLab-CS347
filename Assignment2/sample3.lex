/* scanner for a toy Pascal-like language 
* DECLARE REGION
* Start conditions - States of the finite automaton
* // in declare region -
* %s myStartState
* // in rules -
* <myStartState> {
* 	regex_pattern action();
* }
* 
* Start conditions are declared in the definitions (first) section of the input using unindented lines beginning with either `%s' inclusive) or `%x' (exclusive condition - active only when present alone) followed by a list of names. 
*/

%{
/* need this for the call to atof() below */
#include <math.h>
%}

DIGIT    [0-9]
ID       [a-z][a-z0-9]*

%%

%{
/* 
RULES REGION 
note less pop regex patterns - 
`r{2,}' : two or more r's
`<s>r'    an r, but only in start condition s

valid "expressions" - 
[:alnum:] [:alpha:] [:blank:]
[:cntrl:] [:digit:] [:graph:]
[:lower:] [:print:] [:punct:]
[:space:] [:upper:] [:xdigit:]

Note: A negated character class such as the example "[^A-Z]" above will match a newline unless "\n" (or an equivalent escape sequence) is one of the characters explicitly present in the negated character class (e.g., "[^A-Z\n]"). This is unlike how many other regular expression tools treat negated character classes, but unfortunately the inconsistency is historically entrenched. 
Matching newlines means that a pattern like [^"]* can match the entire input unless there's another quote in the input. 


*/
%}

{DIGIT}+    {
            printf( "An integer: %s (%d)\n", yytext,
                    atoi( yytext ) );
            }

{DIGIT}+"."{DIGIT}*        {
            printf( "A float: %s (%g)\n", yytext,
                    atof( yytext ) );
            }

if|then|begin|end|procedure|function        {
            printf( "A keyword: %s\n", yytext );
            }

{ID}        printf( "An identifier: %s\n", yytext );

"+"|"-"|"*"|"/"   printf( "An operator: %s\n", yytext );

"{"[^}\n]*"}"     /* eat up one-line comments */

[ \t\n]+          /* eat up whitespace */

.           printf( "Unrecognized character: %s\n", yytext );

%%

/*
USER CODE REGION
*/

main( argc, argv )
int argc;
char **argv;
    {
    ++argv, --argc;  /* skip over program name */
    if ( argc > 0 )
            yyin = fopen( argv[0], "r" );
    else
            yyin = stdin;

    yylex();
    }