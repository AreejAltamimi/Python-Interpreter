#ifndef __SYMBOL_TABLE_MANAGER_H__
#define __SYMBOL_TABLE_MANAGER_H__

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <algorithm>
#include "symbolTable.h"

class SymbolTableManager{
public:
    static  SymbolTableManager& getInstance();
    void    makeSymbolTable();
    void    removeSymbolTable();
    const   Literal* getValue(std::string name) const;
    void    setValue(std::string name, const Literal* val);
    Node*   getFunctionTable(std::string name);
    void    setFunctionTable(const std::string& name, Node* func);
    const   Literal* getGlobalValue(std::string name) const;
    void    setGlobalValue(std::string name, const Literal* val);
    int     funcDepth = 0;
    bool    getFlag(std::string name) const;
    void    setFlag(std::string name);

private:
    std::vector<SymbolTable*> scope;
    std::map<std::string, Node*> functionTable; 
    std::map<std::string, bool> global;
    SymbolTableManager() {
        scope.reserve(10);
    	SymbolTable* st = new SymbolTable();
	scope.push_back(st);
   	PoolOfNodes::getInstance().addSymbolTable(st);
    }
};

#endif
