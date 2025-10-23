%{
    #include <bits/stdc++.h>
    using namespace std;

    void yyerror(const char *);
    int yylex();

    unordered_map<string, pair<vector<string>, string>> mp, mp2;
    vector<string> split(string str);
    string replace(vector<string>& _old, vector<string>& _new, string text, int type);
    bool character(char c);
%}

%define api.value.type {std::string}

%token IMPORT FUNCTIONAL_INTERFACE DEFINE CLASS PUBLIC STATIC VOID PRINTLN EXTENDS RETURN INT BOOLEAN TRUE FALSE IF ELSE WHILE THIS NEW 
%token AND OR NOT_EQUAL_TO LESS_THAN_OR_EQUAL_TO ARROW
%token IDENTIFIER INTEGER

%type ImportFun MacroDef TypeDec ImportFunction MainClass TypeDeclaration Vars MethodDec MethodDeclaration Args ArgList Stmts Type Statement Exps ExpList M U Expression PrimaryExpression MacroDefinition MacroDefStatement Ids IdList MacroDefExpression Identifier Integer

%left ','
%right '='
%right ARROW
%left OR
%left AND
%left NOT_EQUAL_TO
%left LESS_THAN_OR_EQUAL_TO
%left '+' '-'
%left '*' '/'
%right '!'
%left '.'

%%

Goal
    : ImportFun MacroDef MainClass TypeDec { 
        string res = $1 + $2 + $3 + $4;
        cout << res;
    }
    ;
ImportFun
    : { $$ = ""; }
    | ImportFunction { $$ = $1 + "\n"; }
    ;
MacroDef
    : { $$ = ""; }
    | MacroDef MacroDefinition { $$ = ""; }
    ;
TypeDec
    : { $$ = ""; }
    | TypeDec TypeDeclaration { 
        string res = $1 + $2;
        $$ = res;
    }
    ;

ImportFunction
    : IMPORT FUNCTIONAL_INTERFACE ';' { $$ = "import java.util.function.Function;"; }
    ;

MainClass
    : CLASS Identifier '{' PUBLIC STATIC VOID Identifier '(' Identifier '[' ']' Identifier ')' '{' PRINTLN '(' Expression ')' ';' '}' '}' {
        if ($7 != "main") {yyerror("error"); YYABORT;}
        if ($9 != "String") {yyerror("error"); YYABORT;}
        
        string res = "class " + $2 + " {\n";
        res += "    public static void main(String[] " + $12 + ") {\n";
        res += "        System.out.println(" + $17 + ");\n";
        res += "    }\n";
        res += "}\n";
        $$ = res;
    }
    ;

TypeDeclaration
    : CLASS Identifier '{' Vars MethodDec '}' {
        string res = "class " + $2 + " {\n";
        res += $4 + $5;
        res += "}\n";
        $$ = res;
    }
    | CLASS Identifier EXTENDS Identifier '{' Vars MethodDec '}' {
        string res = "class " + $2 + " extends " + $4 + " {\n";
        res += $6 + $7;
        res += "}\n";
        $$ = res;
    }
    ;
Vars
    : { $$ = ""; }
    | Vars Type Identifier ';' { $$ = $1 + "    " + $2 + " " + $3 + ";\n"; }
    ;
MethodDec
    : { $$ = ""; }
    | MethodDec MethodDeclaration { $$ = $1 + $2; }
    ;

MethodDeclaration
    : PUBLIC Type Identifier '(' Args ')' '{' Vars Stmts RETURN Expression ';' '}' {
        string res = "    public " + $2 + " " + $3 + "(" + $5 + ") {\n";
        res += "        " + $8 + $9;
        res += "        return " + $11 + ";\n";
        res += "    }\n";
        $$ = res;
    }
    ;
Args
    : { $$ = ""; }
    | Type Identifier ArgList { $$ = $1 + " " + $2 + $3; }
    ;
ArgList
    : { $$ = ""; }
    | ArgList ',' Type Identifier { $$ = $1 + "," + $3 + " " + $4; }
    ;
Stmts
    : { $$ = ""; }
    | Statement Stmts { $$ = $1 + $2; }
    ;

Type
    : INT '[' ']' { $$ = "int[]"; }
    | BOOLEAN { $$ = "boolean"; }
    | INT { $$ = "int"; }
    | Identifier { $$ = $1; }
    | Identifier '<' Identifier ',' Identifier '>' {
        if ($1 != "Function") {yyerror("error"); YYABORT;}
        $$ = $1 + "<" + $3 + ", " + $5 + ">";
    }
    ;

Statement
    : M { $$ = $1 + "\n"; }
    | U { $$ = $1 + "\n"; }
    ;
Exps
    : { $$ = ""; }
    | Expression ExpList { $$ = $1 + $2; }
    ;
ExpList
    : { $$ = ""; }
    | ExpList ',' Expression { $$ = $1 + "," + $3; }
    ;
M
    : IF '(' Expression ')' M ELSE M { $$ = "if (" + $3 + ") " + $5 + " else " + $7; }
    | '{' Stmts '}' { $$ = "{" + $2 + "}"; }
    | PRINTLN '(' Expression ')' ';' { $$ = "System.out.println(" + $3 + ");"; }
    | Identifier '=' Expression ';' { $$ = $1 + " = " + $3 + ";"; }
    | Identifier '[' Expression ']' '=' Expression ';' { $$ = $1 + "[" + $3 + "] = " + $6 + ";"; }
    | WHILE '(' Expression ')' M { $$ = "while (" + $3 + ") " + $5; }
    | Identifier '(' Exps ')' ';' {
        auto it = mp2.find($1);
        if (it == mp2.end()) {
            yyerror("error");
            YYABORT;
        }
        vector<string> args = split($3);
        if ((it->second).first.size() != args.size()) {
            yyerror("error");
            YYABORT;
        }
        $$ = "{" + replace((it->second).first, args, (it->second).second, 1) + "}";
    }
    ;
U
    : IF '(' Expression ')' Statement { $$ = "if (" + $3 + ") " + $5; }
    | IF '(' Expression ')' M ELSE U { $$ = "if (" + $3 + ") " + $5 + " else " + $7; }
    | WHILE '(' Expression ')' U { $$ = "while (" + $3 + ") " + $5; }
    ;

Expression
    : PrimaryExpression AND PrimaryExpression { $$ = $1 + " && " + $3; }
    | PrimaryExpression OR PrimaryExpression { $$ = $1 + " || " + $3; }
    | PrimaryExpression NOT_EQUAL_TO PrimaryExpression { $$ = $1 + " != " + $3; }
    | PrimaryExpression LESS_THAN_OR_EQUAL_TO PrimaryExpression { $$ = $1 + " <= " + $3; }
    | PrimaryExpression '+' PrimaryExpression { $$ = $1 + " + " + $3; }
    | PrimaryExpression '-' PrimaryExpression { $$ = $1 + " - " + $3; }
    | PrimaryExpression '*' PrimaryExpression { $$ = $1 + " * " + $3; }
    | PrimaryExpression '/' PrimaryExpression { $$ = $1 + " / " + $3; }
    | PrimaryExpression '[' PrimaryExpression ']' { $$ = $1 + "[" + $3 + "]"; }
    | PrimaryExpression '.' Identifier {
        if ($3 != "length") {yyerror("error"); YYABORT;}
        $$ = $1 + ".length";
    }
    | PrimaryExpression { $$ = $1; }
    | PrimaryExpression '.' Identifier '(' Exps ')' { $$ = $1 + "." + $3 + "(" + $5 + ")"; }
    | Identifier '(' Exps ')' {
        auto it = mp.find($1);
        if (it == mp.end()) {
            yyerror("error");
            YYABORT;
        }
        vector<string> args = split($3);
        if ((it->second).first.size() != args.size()) {
            yyerror("error");
            YYABORT;
        }
        $$ = replace((it->second).first, args, (it->second).second, 0);
    }
    | '(' Identifier ARROW Expression { $$ = "(" + $2 + ") -> " + $4; }
    ;

PrimaryExpression
    : Integer { $$ = $1; }
    | TRUE { $$ = "true"; }
    | FALSE { $$ = "false"; }
    | Identifier { $$ = $1; }
    | THIS { $$ = "this"; }
    | NEW INT '[' Expression ']' { $$ = "new int[" + $4 + "]"; }
    | NEW Identifier '(' ')' { $$ = "new " + $2 + "()"; }
    | '!' Expression { $$ = "!" + $2; }
    | '(' Expression ')' { $$ = "(" + $2 + ")"; }
    ;

MacroDefinition
    : MacroDefExpression { $$ = ""; }
    | MacroDefStatement { $$ = ""; }
    ;

MacroDefStatement
    : DEFINE Identifier '(' Ids ')' '{' Stmts '}' { 
        $$ = "";
        pair<vector<string>, string> p;
        p.first = split($4);
        p.second = replace(p.first, p.first, $7, 2);
        mp2[$2] = p;
    }
    ;
Ids
    : { $$ = ""; }
    | Identifier IdList { $$ = $1 + $2; }
    ;
IdList
    : { $$ = ""; }
    | IdList ',' Identifier { $$ = $1 + "," + $3; }
    ;

MacroDefExpression
    : DEFINE Identifier '(' Ids ')' '(' Expression ')' { 
        $$ = "";
        pair<vector<string>, string> p;
        p.first = split($4);
        p.second = replace(p.first, p.first, $7, 2);
        mp[$2] = p;
    }
    ;

Identifier
    : IDENTIFIER { $$ = string($1); }
    ;

Integer
    : INTEGER { $$ = to_string(stoi($1)); }
    ;

%%

void yyerror(const char *) {
    cout << "// Failed to parse macrojava code.\n";
}

vector<string> split(string str) {
    stringstream ss(str);
    string id;
    vector<string> args;
    while (getline(ss, id, ',')) {
        args.push_back(id);
    }
    return args;
}

string replace(vector<string>& _old, vector<string>& _new, string text, int type) {
    for (int i = 0; i < (int)_old.size(); ++i) {
        string from, to;
        if (type == 0) { // expression expansion
            from = "<" + to_string(i) + _old[i] + ">";
            to = "(" + _new[i] + ")";
        }
        else if (type == 1) { // statement expansion
            from = "<" + to_string(i) + _old[i] + ">";
            to = _new[i];
        }
        else { // masking "arg" with <"i""arg">
            from = _old[i];
            to = "<" + to_string(i) + _new[i] + ">";
        }
        int j = 0;
        while ((j = text.find(from, j)) != string::npos) {
            if (j && character(text[j - 1])) {
                ++j;
            }
            else if (j + from.length() < text.size() && character(text[j + from.length()])){
                ++j;
            }
            else {
                text.replace(j, from.length(), to);
                j += to.length();
            }
        }
    }
    return text;
}

bool character(char c) {
    if ((c - 'a') >= 0 && ('z' - c) >= 0) {
         return true;
    }
    if ((c - 'A') >= 0 && ('Z' - c) >= 0) {
        return true;
    }
    if ('0' <= c && c <= '9') {
         return true;
    }
    if (c == '_') {
        return true;
    }
    if (c == '$') {
        return true;
    }
    return false;
}

int main() {
    return yyparse();
}
