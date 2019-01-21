#ifndef FUNCTABLE__H
#define FUNCTABLE__H

#include <iostream>
#include <string>
#include <map>
#include <vector>

class Node;

class FuncTable {
public:
  FuncTable() : functions() {}
  const Node* getSuite(const std::string& name) const;
  const Node* getParameters(const std::string& name) const;
private:
  std::map<std::string,std::pair<const Node*, const Node*> > functions;
};

#endif
