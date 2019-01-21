// Generated by transforming |cwd:///work-in-progress/2.7.2-bisonified.y| on 2016-11-23 at 15:46:56 +0000
%{ 
    #include <iostream>
    #include <map>
    #include <vector>
	#include <cmath>
    #include <string>
	#include <tuple>
	#include "includes/ast.h"
    #include "includes/symbolTableManager.h"

	int yylex (void);
	extern char *yytext;
	void yyerror (const char *);
	std::vector<Node*> tests;
	std::vector<std::vector<Node*>*> suites;
    PoolOfNodes& pool = PoolOfNodes::getInstance();
	PoolOfIndices& slicePool = PoolOfIndices::getInstance();

// McCabe Complexity
	std::string funcName;
	int complexity;
	int lineNo;
	bool needCleanup; // handle try + finally
	void initComplexity();
	void printComplexity();
	int counter;
	//Literal* none = new IntLiteral(INF);


	bool slcFlag = false;
	bool idxFlag = false;
	int ifDepth;
	Literal* zero = new IntLiteral(0);
	Literal* one  = new IntLiteral(1);
	Literal* none = new IntLiteral(INF);
%}

/** %union {
  char *id;
  int flag;
  Node* node;
  std::vector<Node*>* vec;
  int intNumber;
  float fltNumber;
  int tokenType;}**/
%union
{
	char* id;
    char* str;
  	int intNumber;
 	long double floatNumber;
  	Node* node;
    std::vector<Node *> * stmts;
}

// 83 tokens, in alphabetical order:
%token AMPEREQUAL AMPERSAND AND AS ASSERT AT BACKQUOTE BAR BREAK CIRCUMFLEX
%token CIRCUMFLEXEQUAL CLASS COLON COMMA CONTINUE DEDENT DEF DEL DOT DOUBLESLASH
%token DOUBLESLASHEQUAL DOUBLESTAR DOUBLESTAREQUAL ELIF ELSE ENDMARKER EQEQUAL
%token EQUAL EXCEPT EXEC FINALLY FOR FROM GLOBAL GREATER GREATEREQUAL GRLT
%token IF IMPORT IN INDENT IS LAMBDA LBRACE LEFTSHIFT LEFTSHIFTEQUAL LESS
%token LESSEQUAL LPAR LSQB MINEQUAL MINUS NAME NEWLINE NOT NOTEQUAL NUMBER
%token OR PASS PERCENT PERCENTEQUAL PLUS PLUSEQUAL PRINT RAISE RBRACE RETURN
%token RIGHTSHIFT RIGHTSHIFTEQUAL RPAR RSQB SEMI SLASH SLASHEQUAL STAR STAREQUAL
%token TILDE TRY VBAREQUAL WHILE WITH YIELD INTNUMBER FLOATNUMBER
%token <str> STRING
%type <id> NAME
%type <intNumber> INTNUMBER pick_PLUS_MINUS pick_unop pick_multop augassign comp_op
%type <floatNumber> FLOATNUMBER
%type <data> star_ELIF
%type <stmts> suite plus_stmt global_stmt star_COMMA_NAME star_trailer trailer arglist opt_arglist parameters star_fpdef_COMMA varargslist star_argument_COMMA
%type <node> atom testlist testlist_comp opt_yield_test pick_yield_expr_testlist_comp power factor term arith_expr shift_expr and_expr xor_expr expr comparison not_test and_test or_test test opt_test print_stmt star_EQUAL pick_yield_expr_testlist expr_stmt opt_DOUBLESTAR_NAME file_input pick_NEWLINE_stmt star_NEWLINE_stmt small_stmt star_EQUAL_Right
%type <node> funcdef return_stmt compound_stmt if_stmt flow_stmt stmt simple_stmt fpdef pick_argument argument while_stmt break_stmt plus_STRING opt_test_only opt_sliceop sliceop
%start start

%locations

%%

/**%type<node> yield_expr old_lambdef lambdef opt_dictorsetmaker testlist1 star_EQUAL print_stmt stmt simple_stmt small_stmt
%type<node> if_stmt flow_stmt return_stmt
%type<flag> star_trailer trailer
%type<vec> plus_stmt**/

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt ENDMARKER  { $$ = $1; } 
	;
pick_NEWLINE_stmt // Used in: star_NEWLINE_stmt
	: NEWLINE  { return NEWLINE; } 
	| stmt     { $$ = $1; }  
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt pick_NEWLINE_stmt  { $$ = $2; }
	| %empty                               { $$ = NULL; }
	;
decorator // Used in: decorators
	: AT dotted_name LPAR opt_arglist RPAR NEWLINE
	| AT dotted_name NEWLINE
	;
opt_arglist // Used in: decorator, trailer
	: arglist    { $$ = $1; }
	| %empty     { $$ = NULL; }
	;
decorators // Used in: decorators, decorated
	: decorators decorator
	| decorator
	;
decorated // Used in: compound_stmt
	: decorators classdef  
	| decorators funcdef   
	;
funcdef // Used in: decorated, compound_stmt

// DEF NAME { initComplexity(); } parameters COLON suite {
//lineNo = @$.first_line;
	: DEF NAME { SymbolTableManager::getInstance().funcDepth += 1; } parameters COLON suite 
          { 
              if($2 != NULL && $6 != NULL)
              {   
              	  Node* n = new IdentNode($2);
		  if($4 == NULL)
                  {


		      $4 = new std::vector<Node*>;
		      pool.addVec($4);


		  }


                  Node* func = new FuncNode(n, $4, $6, SymbolTableManager::getInstance().funcDepth);


                  if(SymbolTableManager::getInstance().funcDepth == 0) { $$ = func; }
                  else { $$ = NULL; }


                  const std::string id = static_cast<IdentNode*>(n)->getIdent();
	          SymbolTableManager::getInstance().setFunctionTable(id,func);
                  pool.add(n);

                  pool.add(func);
              }



	      SymbolTableManager::getInstance().funcDepth -= 1;
              delete [] $2; 
          }
	;
parameters // Used in: funcdef
	: LPAR varargslist RPAR  { $$ = $2;}  
	| LPAR RPAR              { $$ = NULL; }   
	;




varargslist // Used in: parameters, old_lambdef, lambdef
	: star_fpdef_COMMA pick_STAR_DOUBLESTAR  { $$ = NULL; }
	| star_fpdef_COMMA fpdef opt_EQUAL_test opt_COMMA
          { if($1 == NULL)
              {							
                  $$ = new std::vector<Node*>;
		  $$->push_back($2); 
		  pool.addVec($$);
	      }else {
		  $1->push_back($2);
		  $$ = $1;} }
	;





opt_EQUAL_test // Used in: varargslist, star_fpdef_COMMA
	: EQUAL test
	| %empty
	;
star_fpdef_COMMA // Used in: varargslist, star_fpdef_COMMA
	: star_fpdef_COMMA fpdef opt_EQUAL_test COMMA
          {
              if($1 == NULL)
              {							
                  $$ = new std::vector<Node*>;
		  $$->push_back($2); 
		  pool.addVec($$);
	      }
              else
              {
		  $1->push_back($2);
		  $$ = $1;
	      }
          }
	| %empty  { $$ = NULL; }
	;
opt_DOUBLESTAR_NAME // Used in: pick_STAR_DOUBLESTAR
	: COMMA DOUBLESTAR NAME  { delete [] $3; }
	| %empty                 { $$ = NULL; }
	;
pick_STAR_DOUBLESTAR // Used in: varargslist
	: STAR NAME opt_DOUBLESTAR_NAME  { delete [] $2; }
	| DOUBLESTAR NAME                { delete [] $2; }
	;
opt_COMMA // Used in: varargslist, opt_test, opt_test_2, testlist_safe, listmaker, testlist_comp, pick_for_test_test, pick_for_test, pick_argument
	: COMMA
	| %empty
	;
fpdef // Used in: varargslist, star_fpdef_COMMA, fplist, star_fpdef_notest
	: NAME  
          { 
              $$ = new IdentNode($1); 
              delete [] $1; 
              pool.add($$); 
          }
	| LPAR fplist RPAR  { $$ = NULL;}
	;
fplist // Used in: fpdef
	: fpdef star_fpdef_notest COMMA
	| fpdef star_fpdef_notest
	;
star_fpdef_notest // Used in: fplist, star_fpdef_notest
	: star_fpdef_notest COMMA fpdef
	| %empty
	;
stmt // Used in: pick_NEWLINE_stmt, plus_stmt
	: simple_stmt    
          { 
              $$ = $1;
              if(SymbolTableManager::getInstance().funcDepth == 0) { $1->eval(); }
          }
	| compound_stmt  { $$ = $1; }
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt SEMI NEWLINE   { $$ = $1; }
	| small_stmt star_SEMI_small_stmt NEWLINE        { $$ = $1; }
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt SEMI small_stmt 
	| %empty                                
	;
small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: expr_stmt    { $$ = $1; }
	| print_stmt
          {
              $$ = new PrintNode($1); 
              pool.add($$);
          }
	| del_stmt     { $$ = NULL; }
	| pass_stmt    { $$ = NULL; }
	| flow_stmt    { $$ = $1; }
	| import_stmt  { $$ = NULL; }
	| global_stmt  


          {  //std::cout<<"global";


              $$ = new GlobalNode($1); 


              pool.add($$);


          }


	| exec_stmt    { $$ = NULL; }


	| assert_stmt  { $$ = NULL; }
	;


expr_stmt // Used in: small_stmt
	: testlist augassign pick_yield_expr_testlist
          { 
              if($2 == PLUSEQUAL)
              {
                  Node* rhs = new AddBinaryNode($1, $3);
                  $$ = new SuiteNode($1, rhs);
                  pool.add(rhs);
                  pool.add($$);
              }
              if($2 == MINEQUAL)
              {
                  Node* rhs = new SubBinaryNode($1, $3);
                  $$ = new SuiteNode($1, rhs);
                  pool.add(rhs);
                  pool.add($$);
              }
              if($2 == STAREQUAL)
              {
                  Node* rhs = new MulBinaryNode($1, $3);
                  $$ = new SuiteNode($1, rhs);
                  pool.add(rhs);
                  pool.add($$);
              }
              if($2 == SLASHEQUAL)
              {
                  Node* rhs = new DivBinaryNode($1, $3);
                  $$ = new SuiteNode($1, rhs);
                  pool.add(rhs);
                  pool.add($$);
              }
              if($2 == PERCENTEQUAL)
              {
                  Node* rhs = new PercentBinaryNode($1, $3);
                  $$ = new SuiteNode($1, rhs);
                  pool.add(rhs);
                  pool.add($$);
              }
              if($2 == DOUBLESTAREQUAL)
              {
                  Node* rhs = new DoubleStarBinaryNode($1, $3);
                  $$ = new SuiteNode($1, rhs);
                  pool.add(rhs);
                  pool.add($$);
              }
              if($2 == DOUBLESLASHEQUAL)
              {
                  Node* rhs = new DoubleSlashBinaryNode($1, $3);
                  $$ = new SuiteNode($1, rhs);
                  pool.add(rhs);
                  pool.add($$);
              }
          }
	| testlist star_EQUAL
          {
              if($2 != NULL)
              {
                  $$ = new SuiteNode($1, $2);
                  pool.add($$);
              }
              else
              {
                  $$ = $1;
              } 
          }
	;
pick_yield_expr_testlist // Used in: expr_stmt, star_EQUAL
	: yield_expr  { $$ = NULL; }
	| testlist    { $$ = $1; }
	;
star_EQUAL // Used in: star_EQUAL
        : star_EQUAL_Right  { $$ = $1; }
        ;
star_EQUAL_Right // Used in: expr_stmt, star_EQUAL
	: EQUAL pick_yield_expr_testlist star_EQUAL_Right  
          { 
              if($3 == NULL)
              {
                  $$ = $2;
              }
              else
              { 
                  $$ = new SuiteNode($2, $3);
                  pool.add($$);
              }
          } 
	| %empty  { $$ = NULL; }
	;
augassign // Used in: expr_stmt
	: PLUSEQUAL         { $$ = PLUSEQUAL; }
	| MINEQUAL          { $$ = MINEQUAL; } 
	| STAREQUAL         { $$ = STAREQUAL; } 
	| SLASHEQUAL        { $$ = SLASHEQUAL; } 
	| PERCENTEQUAL      { $$ = PERCENTEQUAL; } 
	| AMPEREQUAL        { $$ = AMPEREQUAL; } 
	| VBAREQUAL         { $$ = VBAREQUAL; } 
	| CIRCUMFLEXEQUAL   { $$ = CIRCUMFLEXEQUAL; } 
	| LEFTSHIFTEQUAL    { $$ = LEFTSHIFTEQUAL; } 
	| RIGHTSHIFTEQUAL   { $$ = RIGHTSHIFTEQUAL; } 
	| DOUBLESTAREQUAL   { $$ = DOUBLESTAREQUAL; } 
	| DOUBLESLASHEQUAL  { $$ = DOUBLESLASHEQUAL; } 
	;
print_stmt // Used in: small_stmt
	: PRINT opt_test                    
          { 
              if($2 != NULL) $$ = $2; 
          }
	| PRINT RIGHTSHIFT test opt_test_2  { $$ = NULL; }
	;
star_COMMA_test // Used in: star_COMMA_test, opt_test, listmaker, testlist_comp, testlist, pick_for_test
	: star_COMMA_test COMMA test
	| %empty 
	;
opt_test // Used in: print_stmt
	: test star_COMMA_test opt_COMMA  { $$ = $1; } 
	| %empty                          { $$ = NULL; } 
	;
plus_COMMA_test // Used in: plus_COMMA_test, opt_test_2
	: plus_COMMA_test COMMA test
	| COMMA test
	;
opt_test_2 // Used in: print_stmt
	: plus_COMMA_test opt_COMMA
	| %empty
	;
del_stmt // Used in: small_stmt
	: DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt	 
          { 
	      if($1 == NULL)
	      {
	          $$ = new BreakNode(NULL);
                  pool.add($$);
	      }
          }
	| continue_stmt  { $$ = NULL; }




	| return_stmt    /////////////////// *************
          {
	      if($1 == NULL)
	      {
	          $$ = new ReturnNode(NULL);
                  pool.add($$);
	      }
              else
              {
	          $$ = new ReturnNode($1);
	          pool.add($$);
	      }
	  }   
	| raise_stmt	 { $$ = NULL; }
	| yield_stmt	 { $$ = NULL; }
	;
break_stmt // Used in: flow_stmt
	: BREAK  { $$ = NULL;}
	;
continue_stmt // Used in: flow_stmt
	: CONTINUE
	;
return_stmt // Used in: flow_stmt
	: RETURN testlist    { $$ = $2;}


//**RETURN testlist {$$= new ReturnNode($2);
                      //pool.add($$);}
	//| RETURN {$$= new ReturnNode(nullptr);
         //      pool.add($$);
          //     }**////

	| RETURN             { $$ = NULL;}
	;
yield_stmt // Used in: flow_stmt
	: yield_expr
	;
raise_stmt // Used in: flow_stmt
	: RAISE test opt_test_3
	| RAISE
	;
opt_COMMA_test // Used in: opt_test_3, exec_stmt
	: COMMA test
	| %empty
	;
opt_test_3 // Used in: raise_stmt
	: COMMA test opt_COMMA_test
	| %empty
	;
import_stmt // Used in: small_stmt
	: import_name
	| import_from
	;
import_name // Used in: import_stmt
	: IMPORT dotted_as_names
	;
import_from // Used in: import_stmt
	: FROM pick_dotted_name IMPORT pick_STAR_import
	;
pick_dotted_name // Used in: import_from
	: star_DOT dotted_name
	| star_DOT DOT
	;
pick_STAR_import // Used in: import_from
	: STAR
	| LPAR import_as_names RPAR
	| import_as_names
	;
import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: NAME AS NAME  { delete [] $1; delete [] $3; }
	| NAME          { delete [] $1; }
	;
dotted_as_name // Used in: dotted_as_names
	: dotted_name AS NAME  { delete [] $3; }
	| dotted_name
	;
import_as_names // Used in: pick_STAR_import
	: import_as_name star_COMMA_import_as_name COMMA
	| import_as_name star_COMMA_import_as_name
	;
star_COMMA_import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: star_COMMA_import_as_name COMMA import_as_name
	| %empty
	;
dotted_as_names // Used in: import_name, dotted_as_names
	: dotted_as_name
	| dotted_as_names COMMA dotted_as_name
	;
dotted_name // Used in: decorator, pick_dotted_name, dotted_as_name, dotted_name
	: NAME                  { delete [] $1; }
	| dotted_name DOT NAME  { delete [] $3; }
	;
global_stmt // Used in: small_stmt
	: GLOBAL NAME star_COMMA_NAME
	  {
	      if($3 == NULL)
              {
                  $$ = new std::vector<Node*>;


//
                  Node* n = new IdentNode($2);

/// 

                  $$ ->push_back(n);
                  pool.add(n);
                  pool.addVec($$);
                  delete [] $2;
              }


 else ////////////////////////
              {


                  Node* n = new IdentNode($2);
                  $3->push_back(n);
                  $$ = $3;
	          pool.add(n);


                  delete [] $2;
              }
	  }
	;
star_COMMA_NAME // Used in: global_stmt, star_COMMA_NAME
	: star_COMMA_NAME COMMA NAME 
          { 
	      if($1 == NULL)
              {
                  $$ = new std::vector<Node*>;
                  Node* n = new IdentNode($3);



                  $$ ->push_back(n);
                  pool.add(n);
	          pool.addVec($$);
	          delete [] $3;
              }/////////////////////////////////



              else
              {
	          Node* n = new IdentNode($3);
                  $1->push_back(n);
                  $$ = $1;
                  pool.add(n);
	          delete [] $3;
              }
          }
	| %empty  { $$ = NULL; }                
	;
exec_stmt // Used in: small_stmt
	: EXEC expr IN test opt_COMMA_test
	| EXEC expr
	;
assert_stmt // Used in: small_stmt
	: ASSERT test COMMA test
	| ASSERT test
	;
compound_stmt // Used in: stmt
	: { SymbolTableManager::getInstance().funcDepth += 1; } if_stmt     { $$ = $2; } 
	| while_stmt  { $$ = $1; }
	| for_stmt    { $$ = NULL; }
	| try_stmt    { $$ = NULL; }
	| with_stmt   { $$ = NULL; }
	| funcdef     { $$ = $1; }
	| classdef    { $$ = NULL; }
	| decorated   { $$ = NULL; }
	;



if_stmt // Used in: compound_stmt
	: IF test COLON suite star_ELIF ELSE COLON suite
	{
		tests.insert(tests.begin(),$2);
		suites.insert(suites.begin(),$4);
		suites.push_back($8);




//////////////////////////////////////

		Node* ifelse = new IfNode(tests, suites, true); 
		SymbolTableManager::getInstance().funcDepth -= 1;
		if(SymbolTableManager::getInstance().funcDepth == 0){
			const Node* res = ifelse->eval();



			if(res != NULL)	{


				$$ = const_cast<Node*>(res);
			}else {
				$$ = new IntLiteral(INF);
	
			}
			$$ = NULL;
		}else{
			$$ = ifelse;
		}
	}
	| IF test COLON suite star_ELIF
	{
		tests.insert(tests.begin(),$2);
		suites.insert(suites.begin(),$4);
		Node* elif = new IfNode(tests, suites, false); 
		SymbolTableManager::getInstance().funcDepth -= 1;
		if(SymbolTableManager::getInstance().funcDepth == 0){
			const Node* res = elif->eval();					
			if(res != NULL)	{
				$$ = const_cast<Node*>(res);
			}else {
				$$ = new IntLiteral(INF);
	
			}
			$$ = NULL;
		}else{
			$$ = elif;		
		}
	}
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF ELIF test COLON suite 
	{
		tests.push_back($3);
		suites.push_back($5);
	}
	| %empty 
	{
		tests.clear();suites.clear(); 
	}
	;
while_stmt // Used in: compound_stmt
	: WHILE test COLON suite ELSE COLON suite
          { $$ = new WhileNode($2, $4); $$-> eval(); pool.add($$); }
	| WHILE test COLON suite
          { $$ = new WhileNode($2, $4); $$-> eval(); pool.add($$); }
	;
for_stmt // Used in: compound_stmt
	: FOR exprlist IN testlist COLON suite ELSE COLON suite
	| FOR exprlist IN testlist COLON suite
	;
try_stmt // Used in: compound_stmt
	: TRY COLON suite plus_except opt_ELSE opt_FINALLY
	| TRY COLON suite FINALLY COLON suite
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause COLON suite
	| except_clause COLON suite
	;
opt_ELSE // Used in: try_stmt
	: ELSE COLON suite
	| %empty
	;
opt_FINALLY // Used in: try_stmt
	: FINALLY COLON suite
	| %empty
	;
with_stmt // Used in: compound_stmt
	: WITH with_item star_COMMA_with_item COLON suite
	;
star_COMMA_with_item // Used in: with_stmt, star_COMMA_with_item
	: star_COMMA_with_item COMMA with_item
	| %empty
	;
with_item // Used in: with_stmt, star_COMMA_with_item
	: test AS expr
	| test
	;
except_clause // Used in: plus_except
	: EXCEPT test opt_AS_COMMA
	| EXCEPT
	;
pick_AS_COMMA // Used in: opt_AS_COMMA
	: AS
	| COMMA
	;
opt_AS_COMMA // Used in: except_clause
	: pick_AS_COMMA test
	| %empty
	;
suite // Used in: funcdef, if_stmt, star_ELIF, while_stmt, for_stmt, try_stmt, plus_except, opt_ELSE, opt_FINALLY, with_stmt, classdef
	: simple_stmt
	  {
	      $$ = new std::vector<Node*>;
              $$ -> push_back($1);
              pool.addVec($$);
	  }
	| NEWLINE INDENT plus_stmt DEDENT
          {   
              $$ = $3; 
          }
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	  {
              if($2!=NULL) $1 -> push_back($2); 
	      $$ = $1;
	  }
	| stmt
	  {
	      $$ = new std::vector<Node*>;
              if($1 !=NULL) $$ -> push_back($1);
              pool.addVec($$);
	  }
	;
testlist_safe // Used in: list_for
	: old_test plus_COMMA_old_test opt_COMMA
	| old_test
	;
plus_COMMA_old_test // Used in: testlist_safe, plus_COMMA_old_test
	: plus_COMMA_old_test COMMA old_test
	| COMMA old_test
	;
old_test // Used in: testlist_safe, plus_COMMA_old_test, old_lambdef, list_if, comp_if
	: or_test
	| old_lambdef
	;
old_lambdef // Used in: old_test
	: LAMBDA varargslist COLON old_test
	| LAMBDA COLON old_test
	;
test // Used in: opt_EQUAL_test, print_stmt, star_COMMA_test, opt_test, plus_COMMA_test, raise_stmt, opt_COMMA_test, opt_test_3, exec_stmt, assert_stmt, if_stmt, star_ELIF, while_stmt, with_item, except_clause, opt_AS_COMMA, opt_IF_ELSE, listmaker, testlist_comp, lambdef, subscript, opt_test_only, sliceop, testlist, dictorsetmaker, star_test_COLON_test, opt_DOUBLESTAR_test, pick_argument, argument, testlist1
	: or_test opt_IF_ELSE  { $$ = $1; }
	| lambdef              { $$ = NULL; }
	;
opt_IF_ELSE // Used in: test
	: IF or_test ELSE test
	| %empty
	;
or_test // Used in: old_test, test, opt_IF_ELSE, or_test, comp_for
	: and_test             { $$ = $1; }
	| or_test OR and_test  { $$ = NULL; }
	;
and_test // Used in: or_test, and_test
	: not_test               { $$ = $1; }
	| and_test AND not_test  { $$ = NULL; }
	;
not_test // Used in: and_test, not_test
	: NOT not_test  { $$ = NULL; }
	| comparison    { $$ = $1; }
	;
comparison // Used in: not_test, comparison
	: expr  { $$ = $1; }
	| comparison comp_op expr  
          { 
              if($2 == 1)
	      { 
	          $$ = new LessBinaryNode($1, $3);
                  pool.add($$);							
              }
              if($2 == 2)
              {
	          $$ = new GreaterBinaryNode($1, $3);
                  pool.add($$);
	      }
              if($2 == 3)
              {
	          $$ = new EqEqualBinaryNode($1, $3);
                  pool.add($$);
	      }
              if($2 == 4)
              {
	          $$ = new GreaterEqualBinaryNode($1, $3);
                  pool.add($$);									
              } 
              if($2 == 5)
              {
	          $$ = new LessEqualBinaryNode($1, $3);
                  pool.add($$);
	      } 
              if($2 == 7)
              {
	          $$ = new NotEqualBinaryNode($1, $3);
                  pool.add($$);									
              } 
          }
	;
comp_op // Used in: comparison

///////////////////////////////////////////////////////////
	: LESS           { $$ = 1; }//{$$= LESS;}

	| GREATER        { $$ = 2; }// {$$= GREATER;}

	| EQEQUAL        { $$ = 3; }//{$$ = EQEQUAL;}

	| GREATEREQUAL   { $$ = 4; }//{$$=GREATEREQUAL;}

	| LESSEQUAL      { $$ = 5; }//{$$ =LESSEQUAL;}

	| GRLT           { $$ = 6; }

	| NOTEQUAL       { $$ = 7; }//{$$ = NOTEQUAL; }

	| IN             { $$ = 8; }

	| NOT IN         { $$ = 9; }

	| IS             { $$ = 10; }

	| IS NOT         { $$ = 11; }


//////////////////////////////////////////////
	;
expr // Used in: exec_stmt, with_item, comparison, expr, exprlist, star_COMMA_expr
	: xor_expr           { $$ = $1; }
	| expr BAR xor_expr  { $$ = NULL; }
	;
xor_expr // Used in: expr, xor_expr
	: and_expr                      { $$ = $1; }
	| xor_expr CIRCUMFLEX and_expr  { $$ = NULL; }
	;
and_expr // Used in: xor_expr, and_expr
	: shift_expr                     { $$ = $1; }
	| and_expr AMPERSAND shift_expr  { $$ = NULL; }
	;
shift_expr // Used in: and_expr, shift_expr
	: arith_expr                                       { $$ = $1; }
	| shift_expr pick_LEFTSHIFT_RIGHTSHIFT arith_expr  { $$ = NULL; }    
	;
pick_LEFTSHIFT_RIGHTSHIFT // Used in: shift_expr
	: LEFTSHIFT
	| RIGHTSHIFT
	;
arith_expr // Used in: shift_expr, arith_expr
	: term  
          { 
              $$ = $1; 
          }
	| arith_expr pick_PLUS_MINUS term
          { 
              if ($2 == PLUS)
              {
                  $$ = new AddBinaryNode($1, $3); 
                  pool.add($$);
              }
              if ($2 == MINUS)
              {
                  $$ = new SubBinaryNode($1, $3); 
                  pool.add($$);
              }
          }
	;
pick_PLUS_MINUS // Used in: arith_expr
	: PLUS   { $$ = PLUS; }
	| MINUS  { $$ = MINUS; }
	;
term // Used in: arith_expr, term
	: factor  
          { 
              $$ = $1; 
          }
	| term pick_multop factor 
          { 
              if ($2 == STAR)
              {
                  $$ = new MulBinaryNode($1, $3); 
                  pool.add($$);
              }
              if ($2 == SLASH)
              {
                  $$ = new DivBinaryNode($1, $3); 
                  pool.add($$);
              }
              if ($2 == PERCENT)
              {
                  $$ = new PercentBinaryNode($1, $3); 
                  pool.add($$);
              }
              if ($2 == DOUBLESLASH)
              {
                  $$ = new DoubleSlashBinaryNode($1, $3); 
                  pool.add($$);
              }
          }
	;
pick_multop // Used in: term
	: STAR         { $$ = STAR; }
	| SLASH        { $$ = SLASH; }
	| PERCENT      { $$ = PERCENT; }
	| DOUBLESLASH  { $$ = DOUBLESLASH; }
	;
factor // Used in: term, factor, power
	: pick_unop factor 
          { 
              if ($1 == PLUS)  $$ = $2;
              if ($1 == MINUS) 
              {



/////////////////////////
                  Node* tmp = new IntLiteral(0);
                  $$ = new SubBinaryNode(tmp, $2); 
                  pool.add(tmp);
                  pool.add($$);
              }
              if ($1 == TILDE) 
              {   //////////////////////////////////////// 


                  Node* tmp = new IntLiteral(-1);
                  $$ = new SubBinaryNode(tmp, $2); 
                  pool.add(tmp);
                  pool.add($$);
              }
          }  
	| power  
          { $$ = $1; }
	;
pick_unop // Used in: factor
	: PLUS   { $$ = PLUS; }
	| MINUS  { $$ = MINUS; }
	| TILDE  { $$ = TILDE; }
	;
power // Used in: factor
	: atom star_trailer DOUBLESTAR factor 
          { 
              if ($2 == NULL && $1 != NULL)
              {
                  $$ = new DoubleStarBinaryNode($1, $4); 
                  pool.add($$);
              }
          }/////////////////////////////////////////
	| atom star_trailer  
	{ 
		if ($2 != NULL && $1 != NULL)
		{
          Node* call = new CallNode($1, $2);
          pool.add(call);
          if(SymbolTableManager::getInstance().funcDepth == 0)
          {
            const Node* res = call->eval();
            if(res != NULL)
            {
              $$= const_cast<Node*>(res);
            }
            else
            {//////////////////////////////

              $$ = new IntLiteral(1000000000);
              pool.add($$);
            }
          }
          else
          {
            $$ = call;
          }
        }
		else if (idxFlag){
			$$ = new SlcBinaryNode(one, $1);
			idxFlag = false;
		}
		else if (slcFlag){
			$$ = new SlcBinaryNode(none, $1);
			slcFlag = false;
		}
        else 
        {
            $$ = $1;
        }
    }
	;
star_trailer // Used in: power, star_trailer
	: star_trailer trailer  { $$ = $2; }
	| %empty                { $$ = NULL; }
	;
atom // Used in: power
	: LPAR opt_yield_test RPAR
          {   $$ = $2;   }
	| LSQB opt_listmaker RSQB
          {   $$ = NULL;   }
	| LBRACE opt_dictorsetmaker RBRACE
          {   $$ = NULL;   }
	| BACKQUOTE testlist1 BACKQUOTE
          {   $$ = NULL;   }
	| NAME        
    {
		if (strcmp($1, "True") == 0)
			$$ = new IntLiteral(1);
		else if (strcmp($1, "False") == 0)
			$$ = new IntLiteral(0);
		else
            $$ = new IdentNode($1);    




    
        delete [] $1;
        pool.add($$);
    }
    | INTNUMBER 
    {
        $$ = new IntLiteral($1);        
        pool.add($$);
    }
    | FLOATNUMBER
    {
        $$ = new FloatLiteral($1);      
        pool.add($$);
    }
	| NUMBER 
          {   $$ = NULL;   }



	| plus_STRING
	;
pick_yield_expr_testlist_comp // Used in: opt_yield_test
	: yield_expr     { $$ = NULL; }
	| testlist_comp  { $$ = $1; }
	;
opt_yield_test // Used in: atom
	: pick_yield_expr_testlist_comp  { $$ = $1; }
	| %empty                         { $$ = NULL; }
	;
opt_listmaker // Used in: atom
	: listmaker
	| %empty
	;
opt_dictorsetmaker // Used in: atom
	: dictorsetmaker
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING STRING {
		const Literal* str = new StrLiteral($2,true);
		$$ = const_cast<Literal*>(*$1->eval() + *str->eval());
		delete [] $1;
		delete  $2;
		delete  str;
	}



	| STRING {
		$$ = new StrLiteral($1,true);
		delete [] $1;
	}
	;
listmaker // Used in: opt_listmaker
	: test list_for
	| test star_COMMA_test opt_COMMA
	;
testlist_comp // Used in: pick_yield_expr_testlist_comp
	: test comp_for                   { $$ = NULL; }
	| test star_COMMA_test opt_COMMA  { $$ = $1; }
	;
lambdef // Used in: test
	: LAMBDA varargslist COLON test
	| LAMBDA COLON test
	;
trailer // Used in: star_trailer
	: LPAR opt_arglist RPAR    
          {
              if($2 == NULL)
              {
	          $$ = new std::vector<Node*>;
		  pool.addVec($$);
              }
	      else
              {                    
                  $$ = $2;
	      }
          } 


	| LSQB { slicePool.clearThePool();} subscriptlist RSQB  {$$ = 0; slcFlag = true;}


	| DOT NAME                 {$$ = 0; delete [] $2;}
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript COMMA 
	| subscript star_COMMA_subscript       
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript COMMA subscript  
	| %empty                                
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: DOT DOT DOT
	| test  { idxFlag=true;slicePool.add(const_cast<Literal*>($1->eval())); }
	| opt_test_only { if ($1 == NULL) slicePool.add(zero); } COLON opt_test_only { if ($4 == NULL) slicePool.add(none); } opt_sliceop 
	{
		if ($6 == NULL)	


			slicePool.add(one);
		else
			slicePool.add(const_cast<Literal*>($6->eval()));

	}
	;
opt_test_only // Used in: subscript
	: test { slicePool.add(const_cast<Literal*>($1->eval()));}
	| %empty {$$ = NULL;}
	;
opt_sliceop // Used in: subscript
	: sliceop
	| %empty {$$ = NULL;}
	;
sliceop // Used in: opt_sliceop
	: COLON test {$$ = $2;}
	| COLON {$$ = NULL;}
	;
exprlist // Used in: del_stmt, for_stmt, list_for, comp_for
	: expr star_COMMA_expr COMMA
	| expr star_COMMA_expr
	;
star_COMMA_expr // Used in: exprlist, star_COMMA_expr
	: star_COMMA_expr COMMA expr
	| %empty
	;
testlist // Used in: expr_stmt, pick_yield_expr_testlist, return_stmt, for_stmt, opt_testlist, yield_expr
	: test star_COMMA_test COMMA  { $$ = NULL; }
	| test star_COMMA_test        { $$ = $1; }
	;
dictorsetmaker // Used in: opt_dictorsetmaker
	: test COLON test pick_for_test_test
	| test pick_for_test
	;
star_test_COLON_test // Used in: star_test_COLON_test, pick_for_test_test
	: star_test_COLON_test COMMA test COLON test
	| %empty
	;
pick_for_test_test // Used in: dictorsetmaker
	: comp_for
	| star_test_COLON_test opt_COMMA
	;
pick_for_test // Used in: dictorsetmaker
	: comp_for
	| star_COMMA_test opt_COMMA
	;
classdef // Used in: decorated, compound_stmt
	: CLASS NAME LPAR opt_testlist RPAR COLON suite  { delete [] $2; }
	| CLASS NAME COLON suite                         { delete [] $2; }
	;
opt_testlist // Used in: classdef
	: testlist
	| %empty
	;
arglist // Used in: opt_arglist
	: star_argument_COMMA pick_argument
          {
             



 if($1 == NULL)
              {
	          $$ = new std::vector<Node*>; 
                  $$->push_back($2);
		  pool.addVec($$);
              }



	      else
              {      


 
                  $1->push_back($2);     


        
                  $$ = $1;
	      }
          } 
	;
star_argument_COMMA // Used in: arglist, star_argument_COMMA



	: star_argument_COMMA argument COMMA 
          {
              if($1 == NULL)


              {
	          $$ = new std::vector<Node*>; 


                  $$->push_back($2);


		  pool.addVec($$);
              }


	      else
              {       
                  $1->push_back($2);  

           
                  $$ = $1;
	      }


          } 


	| %empty  { $$ = NULL; }
	;
star_COMMA_argument // Used in: star_COMMA_argument, pick_argument
	: star_COMMA_argument COMMA argument
	| %empty
	;
opt_DOUBLESTAR_test // Used in: pick_argument
	: COMMA DOUBLESTAR test
	| %empty
	;
pick_argument // Used in: arglist
	: argument opt_COMMA  { $$ = $1;}                                  
	| STAR test star_COMMA_argument opt_DOUBLESTAR_test  { $$ = NULL; }    
	| DOUBLESTAR test  { $$ = NULL; }                                   
	;
argument // Used in: star_argument_COMMA, star_COMMA_argument, pick_argument
	: test opt_comp_for    { $$ = $1; }
	| test EQUAL test 
	;
opt_comp_for // Used in: argument
	: comp_for
	| %empty
	;
list_iter // Used in: list_for, list_if
	: list_for
	| list_if
	;
list_for // Used in: listmaker, list_iter
	: FOR exprlist IN testlist_safe list_iter
	| FOR exprlist IN testlist_safe
	;
list_if // Used in: list_iter
	: IF old_test list_iter
	| IF old_test
	;
comp_iter // Used in: comp_for, comp_if
	: comp_for
	| comp_if
	;
comp_for // Used in: testlist_comp, pick_for_test_test, pick_for_test, opt_comp_for, comp_iter
	: FOR exprlist IN or_test comp_iter
	| FOR exprlist IN or_test
	;
comp_if // Used in: comp_iter
	: IF old_test comp_iter
	| IF old_test
	;
testlist1 // Used in: atom, testlist1
	: test
	| testlist1 COMMA test
	;
yield_expr // Used in: pick_yield_expr_testlist, yield_stmt, pick_yield_expr_testlist_comp
	: YIELD testlist
	| YIELD
	;
star_DOT // Used in: pick_dotted_name, star_DOT
	: star_DOT DOT
	| %empty
	;

%%





#include <stdio.h>
void yyerror (const char *s)
{
    if(yylloc.first_line > 0)	{
        fprintf (stderr, "%d.%d-%d.%d:", yylloc.first_line, yylloc.first_column,
	                                     yylloc.last_line,  yylloc.last_column);
    }
    fprintf(stderr, " %s with [%s]\n", s, yytext);
}
///////////////////// complexity

void initComplexity() 
{
	funcName = std::string(yytext);	
	complexity = 1;
	needCleanup = false;
}

void printComplexity() 
{
	std::cout << "(\"" << lineNo << ":0: '" << funcName << "'\", " << complexity << ")" << std::endl;
}
