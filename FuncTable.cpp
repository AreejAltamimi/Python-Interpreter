#include <map>
#include <algorithm>
#include "FuncTable.h"
#include "node.h"
#include <vector>




const Node* FuncTable::getParameters(const std::string& name) const {
  std::map<std::string,std::pair< const Node*, const Node*> >::const_iterator it =
    functions.find(name);
  if ( it == functions.end() ) throw name+std::string("not found");
  return it->second.first;
}

void FuncTable::setValue(const std::string& name,const Node* parameters, const Node* suite) {
    functions[name] = std::make_pair(parameters,suite);

}




