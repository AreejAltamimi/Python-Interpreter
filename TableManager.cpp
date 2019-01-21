
#include "TableManager.h"
#include <iostream>
#include "literal.h"

TableManager & TableManager::getInstance() {
  static TableManager  instance;
  return instance;
}



const Node* TableManager::getSuite(const std::string& name) const {
  int scope = functions.size()-1;
  if (functions[scope].found(name))
  const Node* suite = functions[scope].getSuite(name);

  return suite;
   }
   else
     {
       if (functions.size()>1)
       {
        scope = functions.size()-2;
        while (scope !=-1)
        {
        if (functions[scope].found(name))
        {
        const Node* suite = functions[scope].getSuite(name);

        return suite;
        }
          --scope;
      }


       }
     }
return nullptr;
}






















const Node* TableManager::getParameters(const std::string& name) const {
  int scope = functions.size()-1;
  if (functions[scope].found(name))
  { 

  const Node *  parameters = functions[scope].getParameters(name);

  return parameters;
   }
   else
     {
       if (functions.size()>1)
       {
        scope = functions.size()-2;
        while (scope !=-1)
        {
        if (functions[scope].found(name))
        {
        const Node *  parameters = functions[scope].getParameters(name);

        return parameters;
        }
          --scope;
      }
       }
     }
return nullptr;
}


  
