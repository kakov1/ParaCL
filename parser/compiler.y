%language "c++"

%skeleton "lalr1.cc"
%defines
%define api.value.type variant
%param {yy::PDriver* driver}


%code requires
{
#include <iostream>
#include <string>
#include <utility>
#include <vector>

#include "inode.hh"

namespace yy { class PDriver; } 
}

%code
{

#include "driver.hpp"

namespace yy {

parser::token_type yylex(parser::semantic_type* yylval,
                         parser::location_type* yylloc,
                         PDriver* driver);

}                                 
}

%defines

%token NAME VALUE
%token WHILE IF
%token SCOLON LB RB LCB RCB
%token SCAN PRINT

%right ASSIGN
%left IS_EQ IS_GE IS_GT IS_LE IS_LT IS_NE
%left PLUS MINUS MUL DIV MOD

%token <int> NUMBER;
%token <std::string> ID;

%nterm <ast::pINode> stm;
%nterm <ast::pINode> stms;
%nterm <ast::pINode> if;
%nterm <ast::pINode> while;
%nterm <ast::pINode> print;
%nterm <ast::pINode> scan;
%nterm <ast::pINode> assign;
%nterm <ast::pINode> expr;
%nterm <ast::pINode> expr_un;
%nterm <ast::pINode> expr_term;
%nterm <ast::pINode> var;

%nterm <ast::pIScope> scope;

%%

program:     stms                           { ast::current_scope->calc(); }

scope:       op_sc stms cl_sc               {}

op_sc:       LCB                            { ast::current_scope = ast::makeScope(ast::current_scope); }

cl_sc:       RCB                            { ast::current_scope = ast::current_scope->parentScope(); }

stms:        stm                            { ast::current_scope->push($1); }
           | stms stm                       { ast::current_scope->push($2); }

stm:         assign                         { $$ = $1; }
           | if                             { $$ = $1; }
           | while                          { $$ = $1; }
           | print                          { $$ = $1; }
           | scan                           { $$ = $1; }

assign:      var ASSIGN expr SCOLON         { $$ = ast::makeBinOp($1, ast::BinOp::Assign, $3); }

expr:        expr PLUS  expr                { $$ = ast::makeBinOp($1, ast::BinOp::Plus , $3); }
           | expr MINUS expr                { $$ = ast::makeBinOp($1, ast::BinOp::Minus , $3); }
           | expr MUL   expr                { $$ = ast::makeBinOp($1, ast::BinOp::Mul , $3); }
           | expr DIV   expr                { $$ = ast::makeBinOp($1, ast::BinOp::Div , $3); }
           | expr MOD   expr                { $$ = ast::makeBinOp($1, ast::BinOp::Mod , $3); }
           | expr IS_EQ expr                { $$ = ast::makeBinOp($1, ast::BinOp::IsEq, $3); }
           | expr IS_GE expr                { $$ = ast::makeBinOp($1, ast::BinOp::IsGe, $3); }
           | expr IS_GT expr                { $$ = ast::makeBinOp($1, ast::BinOp::IsGt, $3); }
           | expr IS_LT expr                { $$ = ast::makeBinOp($1, ast::BinOp::IsLt, $3); }
           | expr IS_LE expr                { $$ = ast::makeBinOp($1, ast::BinOp::IsLe, $3); }
           | expr IS_NE expr                { $$ = ast::makeBinOp($1, ast::BinOp::IsNe, $3); }
           | expr_un                        { $$ = $1; }

expr_un:     PLUS expr_term                 { $$ = ast::makeUnOp($2, ast::UnOp::Plus); }
           | MINUS expr_term                { $$ = ast::makeUnOp($2, ast::UnOp::Minus); }
           | expr_term

expr_term:   NUMBER                         { $$ = ast::makeValue($1); }
           | ID                             { $$ = ast::makeVar($1); }

if:          IF LB expr RB scope            { $$ = ast::makeIf($3, $5); }
           | IF LB expr RB expr             { $$ = ast::makeIf($3, $5); }

while:       WHILE LB expr RB scope         { $$ = ast::makeWhile($3, $5); }
           | WHILE LB expr RB expr          { $$ = ast::makeWhile($3, $5); }

print:       PRINT expr SCOLON              { $$ = ast::makePrint($2); }

scan:        var ASSIGN SCAN SCOLON         { $$ = ast::makeScan($1); }

var:         ID                             { $$ = ast::makeVar($1); }

%%

namespace yy {

parser::token_type yylex(parser::semantic_type* yylval,
                         parser::location_type* yylloc,
                         PDriver* driver) {
    return driver->yylex(yylval, yylloc);
}

void yy::parser::error(const parser::location_type& location,
                   const std::string& e) {
    std::cerr << e << " in: " << location << "\n";
}

}
