%option noyywrap yylineno
%{
    #include <bits/stdc++.h>
    #include "P1.tab.h"
    using namespace std;
%}

%%

"import"      { return IMPORT; }
"java"[ \t\n\r]*"."[ \t\n\r]*"util"[ \t\n\r]*"."[ \t\n\r]*"function"[ \t\n\r]*"."[ \t\n\r]*"Function" { return FUNCTIONAL_INTERFACE; }
"#define"     { return DEFINE; }
"class"       { return CLASS; }
"public"      { return PUBLIC; }
"static"      { return STATIC; }
"void"        { return VOID; }
"System"[ \t\n\r]*"."[ \t\n\r]*"out"[ \t\n\r]*"."[ \t\n\r]*"println"                               {return PRINTLN; }
"extends"     { return EXTENDS; }
"return"      { return RETURN; }
"int"         { return INT; }
"boolean"     { return BOOLEAN; }
"true"        { return TRUE; }
"false"       { return FALSE; }
"if"          { return IF; }
"else"        { return ELSE; }
"while"       { return WHILE; }
"this"        { return THIS; }
"new"         { return NEW; }


"{" { return '{'; }
"}" { return '}'; }
"(" { return '('; }
")" { return ')'; }
"[" { return '['; }
"]" { return ']'; }
"<" { return '<'; }
">" { return '>'; }

";" { return ';'; }
"," { return ','; }

"=" { return '='; }

"+" { return '+'; }
"-" { return '-'; }
"*" { return '*'; }
"/" { return '/'; }

"&&" { return AND; }
"||" { return OR; }
"!"  { return '!'; }

"!=" { return NOT_EQUAL_TO; }
"<=" { return LESS_THAN_OR_EQUAL_TO; }

"."  { return '.'; }
")"[ \t\n]*"->" { return ARROW; }


[0][bB][01]([_]*[01])*[lL]?               { yylval = to_string(strtol(yytext, nullptr, 2)); return INTEGER; }
[0][xX][0-9a-fA-F]([_]*[0-9a-fA-F])*[lL]? { yylval = to_string(strtol(yytext, nullptr, 16)); return INTEGER; }
[0]([_]*[0-7])*[lL]?                      { yylval = to_string(strtol(yytext, nullptr, 8)); return INTEGER; }
[1-9]([_]*[0-9])*[lL]?                    { yylval = yytext; return INTEGER; }


[a-zA-Z_$][a-zA-Z0-9_$]* { yylval = yytext; return IDENTIFIER; }


"//".*                  { }
"/*"([^*]|"*"[^/])*"*/" { }


[ ]  { }
[\t] { }
[\n] { }
[\r] { }

. { cout << "// Failed to parse macrojava code.\n"; exit(1); }


%%

