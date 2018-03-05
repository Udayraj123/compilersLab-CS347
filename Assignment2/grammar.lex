%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

/*
%start COMMENT 
If the start condition is inclusive(%s), then rules with no start conditions at all will also be active. 
If it is exclusive(%x), then only rules qualified with the start condition will be active
i.e. Do not match any tokens except *_/ when inside a multiline comment

going back to INITIAL state means the patterns with other states as start conditionor without any start condition will become active(when used %x)
>>Also useful to handle inside quotes " do not ignore whitespaces in here."

A number of options are available for lint purists who want to suppress the appearance of unneeded routines in the generated scanner. Each of the following, 
if unset (e.g., %option nounput), results in the corresponding routine not appearing in the generated scanner:
    input, unput
    yy_push_state, yy_pop_state, yy_top_state
    yy_scan_buffer, yy_scan_bytes, yy_scan_string

    yyget_extra, yyset_extra, yyget_leng, yyget_text,
    yyget_lineno, yyset_lineno, yyget_in, yyset_in,
    yyget_out, yyset_out, yyget_lval, yyset_lval,
    yyget_lloc, yyset_lloc, yyget_debug, yyset_debug
(though yy_push_state() and friends won’t appear anyway unless you use %option stack).

Common options include:

%option case-insensitive, which makes the lexer case-insensitive;
%option yylineno, which makes the current line number available in the global C variable yylineno; and
%option noyywrap, which prevents the generated lexer from invoking the user-supplied function yywrap when it reaches the end of the current file.

‘-d, --debug, %option debug’
makes the generated scanner run in debug mode. Whenever a pattern is recognized and the global variable yy_flex_debug is non-zero (which is the default), the scanner will write to stderr a line of the form:

    -accepting rule at line 53 ("the matched text")

‘-p, --perf-report, %option perf-report’
generates a performance report to stderr. The report consists of comments regarding features of the flex input file which will cause a serious loss of performance in the resulting scanner. If you give the flag twice, you will also get comments regarding features that lead to minor performance losses.
*/

%x INSTRING INCOMMENT

%%

[ \r\t\v\f\n]*          { /* eat whitespace */ }
"//".*$                 { /* eat single line comments */ }

"/*"                    { BEGIN(INCOMMENT); /* eat multiline C comments */ }
/*
Inside an action, lex provides a few variables, functions and macros:

char* yytext points to the matched text.
unsigned int yyleng is the length of the matched text.
unsigned int yylineno, if enabled, is the current line.
BEGIN(state) changes to a new lexical state.
ECHO; will print the matched text.
REJECT; will fall through to the next best match.
unput(char) puts a character on the front of the input stream.
return value; will return a value from yylex.
To match end-of-file, use the special pattern <<EOF>

*/
<INCOMMENT>{
        [^*]*           { /* eat comment in chunks */ }
        "*"+[^*/]*      { /* eat the lone star */ }
        "*"+"/"         { BEGIN(INITIAL); }
}
  /* keywords */


