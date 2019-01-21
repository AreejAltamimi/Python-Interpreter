#ifndef TABLEMANAGER__H
#define TABLEMANAGER__H
#include <string>
#include <sstream>
#include <iostream>
#include "symbolTable.h"
#include "FuncTable.h"
#include <vector>

class Node;
class Literal;


class TableManager {
public:
  static TableManager& getInstance();
  void pushScope();
  void popScope();

private:

  TableManager (): stables() , functions()
  {
  stables.push_back(SymbolTable());
  functions.push_back(FuncTable());
  }
};

#endif
