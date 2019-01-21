#include <map>
#include <algorithm>
#include "symbolTable.h"
#include "literal.h"

const Literal* SymbolTable::getValue(const std::string& name) const {
  std::map<std::string, const Literal*>::const_iterator it = table.find(name);
  if ( it == table.end() ) return NULL;
  else return it->second;
}

void SymbolTable::setValue(const std::string& name, const Literal* val) { 
  table[name] = val;
}

