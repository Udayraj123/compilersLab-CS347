%{
#include <math.h>

/*
Here we are trying to show how to define the delta function of the DFA
More macros for states


`void yy_push_state(int new_state)'
    pushes the current start condition onto the top of the start condition stack and switches to new_state as though you had used `BEGIN new_state' (recall that start condition names are also integers). 
`void yy_pop_state()'
    pops the top of the stack and switches to it via BEGIN. 
`int yy_top_state()'
    returns the top of the stack without altering the stack's contents. 
    
*/
%}
%s expect

%%
expect-floats        BEGIN(expect);

<expect>[0-9]+"."[0-9]+      {
            printf( "found a float, = %f\n",
                    atof( yytext ) );
            }
<expect>\n           {
            /* that's the end of the line, so
             * we need another "expect-number"
             * before we'll recognize any more
             * numbers
             */
            BEGIN(INITIAL);
            }

[0-9]+      {
            printf( "found an integer, = %d\n",
                    atoi( yytext ) );
            }

"."         printf( "found a dot\n" );
