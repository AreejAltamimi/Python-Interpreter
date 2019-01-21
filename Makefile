CCC = g++
LEX = flex
YACC = bison
CFLAGS = -w -Wall -std=c++11
LEXFLAGS = -Wno-unused -Wno-sign-compare

#LEXDEBUG = -d
LEXDEBUG =
YACCDEBUG = -vtd

OBJS = main.o parse.tab.o lex.yy.o ast.o symbolTable.o symbolTableManager.o poolOfNodes.o poolOfIndices.o

run: $(OBJS)
	$(CCC) $(CFLAGS) -o run $(OBJS)

main.o: main.cpp includes/parse.y includes/scan.l parse.tab.c lex.yy.c
	$(CCC) $(CFLAGS) -c main.cpp

parse.tab.c: includes/parse.y
	$(YACC) $(YACCDEBUG) includes/parse.y

parse.tab.o: parse.tab.c
	$(CCC) $(CFLAGS) -c parse.tab.c

lex.yy.c: includes/scan.l parse.tab.o
	$(LEX) $(LEXDEBUG) includes/scan.l

lex.yy.o: lex.yy.c
	$(CCC) $(CFLAGS) $(LEXFLAGS) -c lex.yy.c

ast.o: includes/ast.cpp includes/ast.h includes/literal.h
	$(CCC) $(CFLAGS) -c includes/ast.cpp

symbolTable.o: includes/symbolTable.cpp includes/symbolTable.h
	$(CCC) $(CFLAGS) -c includes/symbolTable.cpp

symbolTableManager.o: includes/symbolTableManager.cpp includes/symbolTableManager.h
	$(CCC) $(CFLAGS) -c includes/symbolTableManager.cpp

poolOfNodes.o: includes/poolOfNodes.cpp includes/poolOfNodes.h \
  includes/node.h
	$(CCC) $(CFLAGS) -c includes/poolOfNodes.cpp

poolOfIndices.o: includes/poolOfIndices.cpp includes/poolOfIndices.h \
  includes/literal.h
	$(CCC) $(CFLAGS) -c includes/poolOfIndices.cpp

clean:
	rm -f run *.o parse.tab.c lex.yy.c
	rm -f parse.tab.h
	rm -f parse.output
	rm -f *~
	rm -f includes/*~
	rm -f cases/*~
