#include <iostream>
#include <typeinfo>
#include <sstream>
#include <cmath>
#include <cstdlib>
#include <string>
#include <iomanip>
#include "ast.h"
#include "symbolTableManager.h"

const Literal* IdentNode::eval() const { 
  const Literal* val = SymbolTableManager::getInstance().getValue(ident);
  return val;
}


AsgBinaryNode::AsgBinaryNode(Node* left, Node* right) : 
  BinaryNode(left, right) { 
  const Literal* res = right->eval();
  const std::string n = static_cast<IdentNode*>(left)->getIdent();
  SymbolTableManager::getInstance().setValue(n, res);
}


const Literal* AsgBinaryNode::eval() const { 
  if (!left || !right) {
    throw std::string("error");
  }
  const Literal* res = right->eval();
  const std::string n = static_cast<IdentNode*>(left)->getIdent();
  SymbolTableManager::getInstance().setValue(n, res);
  return res;
}

const Literal* AddBinaryNode::eval() const { 
  if (!left || !right) {
    throw std::string("error");
  }
  const Literal* x = left->eval();
  const Literal* y = right->eval();
  return ((*x)+(*y));
}

const Literal* SubBinaryNode::eval() const { 
  if (!left || !right) {
    throw std::string("error");
  }
  const Literal* x = left->eval();
  const Literal* y = right->eval();
  return ((*x)-(*y));
}

const Literal* MulBinaryNode::eval() const { 
  if (!left || !right) {
    throw std::string("error");
  }
  const Literal* x = left->eval();
  const Literal* y = right->eval();
  return ((*x)*(*y));
}

const Literal* DivBinaryNode::eval() const { 
  if (!left || !right) {
    throw std::string("error");
  }
  const Literal* x = left->eval();
  const Literal* y = right->eval();
  return ((*x)/(*y));
}

const Literal* DoubleStarBinaryNode::eval() const { 
  if (!left || !right) {
    throw std::string("error");
  }
  const Literal* x = left->eval();
  const Literal* y = right->eval();
  return ((*x).doubleStar(*y));
}

const Literal* PercentBinaryNode::eval() const { 
  if (!left || !right) {
    throw std::string("error");
  }
  const Literal* x = left->eval();
  const Literal* y = right->eval();
  return ((*x)%(*y));
}

const Literal* DoubleSlashBinaryNode::eval() const { 
  if (!left || !right) {
    throw std::string("error");
  }
  const Literal* x = left->eval();
  const Literal* y = right->eval();
  return ((*x).doubleSlash(*y));
}

const Literal* FuncNode::eval() const { 
  std::vector<Node*>::iterator it = suite->begin();
  const std::string id = static_cast<IdentNode*>(funcName)->getIdent();
  const Literal* res = NULL;
  while(it != suite->end())
  {
     res = (*it)->eval();
     const Literal* l = SymbolTableManager::getInstance().getValue("RETURN");    
     if(l != NULL)
	break;
     it++;
  }
  if(res != NULL) return res;
  else return NULL;
}

const Literal* PrintNode::eval() const { 
  if (right == nullptr) std::cout << std::endl;
  else
  {  
    const Literal* res = right->eval();
    if(res->getVal() == 1000000000) std::cout<<"None"<<std::endl;    
    else res->eval()->print();
  }
  return NULL;
}

const Literal* GlobalNode::eval() const { 
  std::vector<Node*>::iterator it = vec->begin();
  while(it != vec->end())
  {





    const std::string id = static_cast<IdentNode*>(*it)->getIdent();
    const Literal* res = SymbolTableManager::getInstance().getGlobalValue(id);



    if(res != NULL) SymbolTableManager::getInstance().setValue(id, res);
    SymbolTableManager::getInstance().setFlag(id);
    it++;
  }
  return NULL;
}

const Literal* ReturnNode::eval() const { 

/**
const Literal * ReturnNode::eval()const {
if (returnedVal)
 {
 const Literal* val = returnedVal->eval();
 //std::cout<< "inside return eval"<<std::endl;
 TableManager::getInstance().insertSymbole("return",nullptr);
 reVal = val;
return val;
}
return nullptr;

}
**/
  if(right != NULL)
  {
    const Literal* res = right->eval();
    SymbolTableManager::getInstance().setValue("RETURN", res);
    return res;
  }else{
    const Literal* res = new IntLiteral(1000000000);
    SymbolTableManager::getInstance().setValue("RETURN", res);
    return res;
  }
}

const Literal* BreakNode::eval() const { 
    const Literal* res = new IntLiteral(1000000000);
    SymbolTableManager::getInstance().setValue("BREAK", res);
    return res;
}

const Literal* SuiteNode::eval() const { 
  if (!left || !right) {
    throw std::string("error");
  }
  Node* res = new AsgBinaryNode(left,right);
  PoolOfNodes::getInstance().add(res);
  return NULL;
}

const Literal* CallNode::eval() const{
  SymbolTableManager::getInstance().funcDepth +=1;
  const std::string id = static_cast<IdentNode*>(funcName)->getIdent();
  Node* func = SymbolTableManager::getInstance().getFunctionTable(id);
  SymbolTableManager::getInstance().makeSymbolTable();
  std::vector<Node*>* vec = static_cast<FuncNode*>(func)->getParameters();
  if(vec->size() == parameters->size())
  {
    std::vector<Node*>::const_iterator it1 = vec->begin();
    std::vector<Node*>::const_iterator it2 = parameters->begin();
    while(it1 != vec->end())
    {
      const std::string id = static_cast<IdentNode*>(*it1)->getIdent();
      const Literal* res = (*it2)->eval();
      SymbolTableManager::getInstance().setValue(id, res);
      it1++;
      it2++;
    }
  }
  const Literal* res = func->eval();
  SymbolTableManager::getInstance().removeSymbolTable();
  SymbolTableManager::getInstance().funcDepth -=1;
  if(res == NULL) return NULL;
  else return res;
}

const Literal* IfNode::eval() const {

/**
const Literal * IFNode::eval()const {
  if (!test ) {
    throw "error";
  }
  const Literal* res = test->eval();
  if (res)
      suite->eval();
return nullptr;

}**/
  for (auto test = tests.begin(); test != tests.end(); ++test) {
    const Literal* t = (*test)->eval();
    if(t->getVal()){
      auto suite = suites[test-tests.begin()];
      std::vector<Node*>::iterator it = suite->begin();
      const Literal* res = NULL;
      while(it != suite->end()){
        res = (*it)->eval();
   if(res!= NULL) break;
        it++;
      }
      return res;
    }
  }
  if (got_else){
    auto suite = suites[suites.size()-1];
    std::vector<Node*>::iterator it = suite->begin();
    const Literal* res = NULL;
    while(it != suite->end()){
      res = (*it)->eval();
   if(res!= NULL) break;
      it++;
    }
    return res;
  }
  return NULL;
}
//////////////////////////////



const Literal* WhileNode::eval() const { 
  while(test->eval()->getVal()){
    std::vector<Node*>::iterator it = left->begin();
    const Literal* res = NULL;
    int x = 0;
    while(it != left->end())
    {
      res = (*it)->eval();
      if(res!=NULL) break;
      const Literal* l = SymbolTableManager::getInstance().getValue("BREAK");  
      if(l != NULL){ x = 1; break;}
      it++;
    }
    if (x == 1) break;
    else if ((test->eval()->getVal()) != 0) continue;
    return res;
    
  }
  return NULL;
}

const Literal* LessBinaryNode::eval() const {
  if (!left || !right) {
    throw std::string("error");
  }
  const Literal* x = left->eval();
  const Literal* y = right->eval();
  float l = x->getVal();
  float r = y->getVal();
  if(l < r)
  {
    const Literal* res = new IntLiteral(1);
    PoolOfNodes::getInstance().add(res);
    return res;
  }else{ 
    const Literal* res = new IntLiteral(0);
    PoolOfNodes::getInstance().add(res);
    return res;
  }
}

const Literal* LessEqualBinaryNode::eval() const {
  if (!left || !right) {
    throw std::string("error");
  }
  const Literal* x = left->eval();
  const Literal* y = right->eval();
  float l = x->getVal();
  float r = y->getVal();
  if(l <= r)
  {
    const Literal* res = new IntLiteral(1);
    PoolOfNodes::getInstance().add(res);
    return res;
  }else{ 
    const Literal* res = new IntLiteral(0);
    PoolOfNodes::getInstance().add(res);
    return res;
  }
}

const Literal* GreaterBinaryNode::eval() const {
  if (!left || !right) {
    throw std::string("error");
  }
  const Literal* x = left->eval();
  const Literal* y = right->eval();
  float l = x->getVal();
  float r = y->getVal();
  if(l > r)
  {
    const Literal* res = new IntLiteral(1);
    PoolOfNodes::getInstance().add(res);
    return res;
  }else{ 
    const Literal* res = new IntLiteral(0);
    PoolOfNodes::getInstance().add(res);
    return res;
  }
}

const Literal* GreaterEqualBinaryNode::eval() const {
  if (!left || !right) {
    throw std::string("error");
  }
  const Literal* x = left->eval();
  const Literal* y = right->eval();
  float l = x->getVal();
  float r = y->getVal();
  if(l >= r)
  {
    const Literal* res = new IntLiteral(1);
    PoolOfNodes::getInstance().add(res);
    return res;
  }else{ 
    const Literal* res = new IntLiteral(0);
    PoolOfNodes::getInstance().add(res);
    return res;
  }
}

const Literal* EqEqualBinaryNode::eval() const {
  if (!left || !right) {
    throw std::string("error");
  }
  const Literal* x = left->eval();
  const Literal* y = right->eval();
  float l = x->getVal();
  float r = y->getVal();
  if(l == r)
  {
    const Literal* res = new IntLiteral(1);
    PoolOfNodes::getInstance().add(res);
    return res;
  }else{ 
    const Literal* res = new IntLiteral(0);
    PoolOfNodes::getInstance().add(res);
    return res;
  }
}

const Literal* NotEqualBinaryNode::eval() const {
  if (!left || !right) {
    throw std::string("error");
  }
  const Literal* x = left->eval();
  const Literal* y = right->eval();
  float l = x->getVal();
  float r = y->getVal();
  if(l != r)
  {
    const Literal* res = new IntLiteral(1);
    PoolOfNodes::getInstance().add(res);
    return res;
  }else{ 
    const Literal* res = new IntLiteral(0);
    PoolOfNodes::getInstance().add(res);
    return res;
  }
}
/////////////////////////////////
const Literal* SlcBinaryNode::eval() const {
    if (!left || !right) {
    throw "error";
  }
  const Literal* x = left->eval();
  const Literal* y = right->eval();
  return (*x) [(*y)];
}
