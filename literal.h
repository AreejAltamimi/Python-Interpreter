#include "node.h"
#include <math.h>
#include <string.h>
#include <cmath>
#include <iomanip>  
#include "poolOfNodes.h"
#include "poolOfIndices.h"
 
extern int INF;

class Literal : public Node {
public:
  virtual ~Literal() {}

  virtual const Literal* operator+(const Literal& rhs) const =0;
  virtual const Literal* opPlus(long double) const =0;
  virtual const Literal* opPlus(int) const =0;
  virtual const Literal* opPlus(char*) const = 0;

  virtual const Literal* operator*(const Literal& rhs) const =0;
  virtual const Literal* opMult(long double) const =0;
  virtual const Literal* opMult(int) const =0;
  virtual const Literal* opMult(char*) const = 0;

  virtual const Literal* operator-(const Literal& rhs) const =0;
  virtual const Literal* opSubt(long double) const =0;
  virtual const Literal* opSubt(int) const =0;
  virtual const Literal* opSubt(char*) const = 0;

  virtual const Literal* operator/(const Literal& rhs) const =0;
  virtual const Literal* opDiv(long double) const =0;
  virtual const Literal* opDiv(int) const =0;
  virtual const Literal* opDiv(char*) const = 0;

  virtual const Literal* doubleStar(const Literal& rhs) const =0;
  virtual const Literal* opDStar(long double) const =0;
  virtual const Literal* opDStar(int) const =0;
  virtual const Literal* opDStar(char*) const = 0;

  virtual const Literal* operator%(const Literal& rhs) const =0;
  virtual const Literal* opPerc(long double) const =0;
  virtual const Literal* opPerc(int) const =0;
  virtual const Literal* opPerc(char*) const =0;

  virtual const Literal* doubleSlash(const Literal& rhs) const =0;
  virtual const Literal* opDSlash(long double) const =0;
  virtual const Literal* opDSlash(int) const =0;
  virtual const Literal* opDSlash(char*) const =0;

  virtual const Literal* operator[](const Literal& rhs) const = 0;
  virtual const Literal* opSlice(long double) const = 0;
  virtual const Literal* opSlice(int) const = 0;
  virtual const Literal* opSlice(char*) const = 0;

  virtual float getVal() const =0;
  virtual std::string getType() const =0;

  virtual const Literal* eval() const = 0;
  virtual void print() const { 
    std::cout << "No Way" << std::endl; 
  }
};


////////////////////////////////////////////////






class StrLiteral: public Literal {
public:
  StrLiteral(char* _val,bool quotes=false) { 
    if (quotes){
      int size_str = strlen(_val)-2; 
      val = new char[size_str + 1];     
      int i;
      for (i = 0; i < size_str; ++i) {
        val[i] = _val[i+1];
      }
      val[i] = '\0';                
    }
    else{
      int size_str = strlen(_val); 
      val = new char[size_str + 1];     
      strcpy(val,_val);
    }
  }
//////////////////////////////////////
  virtual const Literal* operator+(const Literal& rhs) const  {
    return rhs.opPlus(val);
  }
  virtual const Literal* opPlus(long double lhs) const {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for +: 'str' and 'float'");
    return NULL;
  }
  virtual const Literal* opPlus(int lhs) const {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for +: 'str' and 'int'");
    return NULL;
  }
  virtual const Literal* opPlus(char* lhs) const  {
    char* cat = new char[strlen(lhs)+strlen(val)+1];
    strcpy(cat,lhs);
    strcat(cat,val);
    const Literal* node = new StrLiteral(cat);
    return node; 
  }

  virtual const Literal* operator-(const Literal& rhs) const {
    return rhs.opSubt(val);
  }
  virtual const Literal* opSubt(long double lhs) const {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for -: 'str' and 'float'");
    return NULL;
  }
  virtual const Literal* opSubt(int lhs) const {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for -: 'str' and 'float'");
    return NULL;
  }
  virtual const Literal* opSubt(char* lhs) const{
    throw std::invalid_argument("TypeError: unsupported operand type(s) for -: 'str' and 'str'");
    return NULL;
  }

  virtual const Literal* operator*(const Literal& rhs) const {
    return rhs.opMult(val);
  }
  virtual const Literal* opMult(long double lhs) const {
    throw std::invalid_argument("TypeError: can't multiply sequence by non-int of type 'float'");
    return NULL;
  }
  virtual const Literal* opMult(int lhs) const {
    char* cat = new char[strlen(val)*lhs+1];
    strcpy(cat,val);
    for (int i = 1; i < lhs; ++i){
      strcat(cat,val);
    }
    const Literal* node = new StrLiteral(cat);
    return node;
  }
  virtual const Literal* opMult(char* lhs) const {
    throw std::invalid_argument("TypeError: can't multiply sequence by non-int of type 'str'");
    return NULL;
  }

  virtual const Literal* operator/(const Literal& rhs) const{
    return rhs.opDiv(val);
  }
  virtual const Literal* opDiv(long double lhs) const {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for /: 'str' and 'float'");
    return NULL;
  }
  virtual const Literal* opDiv(int lhs) const {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for /: 'str' and 'int'");
    return NULL;
  }
  virtual const Literal* opDiv(char* lhs) const {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for /: 'str' and 'str'");
    return NULL;
  }
  
  virtual const Literal* doubleStar(const Literal& rhs) const {
    return rhs.opDStar(val);
  }
  virtual const Literal* opDStar(long double lhs) const {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for **: 'str' and 'float'");
    return NULL;
  }
  virtual const Literal* opDStar(int lhs) const {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for **: 'str' and 'int'");
    return NULL;
  }
  virtual const Literal* opDStar(char* lhs) const {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for **: 'str' and 'str'");
    return NULL;
  }

  virtual const Literal* operator%(const Literal& rhs) const {
    return rhs.opPerc(val);
  }
  virtual const Literal* opPerc(long double lhs) const {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for %: 'str' and 'float'");
    return NULL;
  }
  virtual const Literal* opPerc(int lhs) const {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for %: 'str' and 'int'");
    return NULL;
  }
  virtual const Literal* opPerc(char* lhs) const {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for %: 'str' and 'str'");
    return NULL;
  }

  virtual const Literal* doubleSlash(const Literal& rhs) const {
    return rhs.opDSlash(val);
  }
  virtual const Literal* opDSlash(long double lhs) const {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for **: 'str' and 'float'");
    return NULL;
  }
  virtual const Literal* opDSlash(int lhs) const {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for **: 'str' and 'int'");
    return NULL;
  }
  virtual const Literal* opDSlash(char* lhs) const {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for **: 'str' and 'str'");
    return NULL;
  }

  virtual const Literal* operator[](const Literal& rhs) const {
    return rhs.opSlice(val);
    return NULL;
  }
  virtual const Literal* opSlice(long double lhs) const {
    throw std::invalid_argument("TypeError: string indices must be integers, not float");
    return NULL;
  }
  virtual const Literal* opSlice(int lhs) const {
    std::vector<Literal*> mypool = PoolOfIndices::getInstance().get();
    if (lhs != INF){
      lhs = mypool[0]->getVal();
      if (lhs < 0)
      lhs = strlen(val) + lhs;
    if (!(lhs >= 0 && (size_t)lhs < strlen(val)))
      throw std::invalid_argument("IndexError: string index out of range");
    char* idx = new char[2];
    idx[0] = val[lhs];
    idx[1] = '\0';
    const Literal* node = new StrLiteral(idx);
    return node;
    } else {
      if (mypool[0]->getType() == "float" || mypool[1]->getType() == "float" || mypool[2]->getType() == "float")
        throw std::invalid_argument("TypeError: string indices must be integers, not float");
      else if (mypool[0]->getType() == "str" || mypool[1]->getType() == "str" || mypool[2]->getType() == "str")
        throw std::invalid_argument("TypeError: string indices must be integers, not str");












      int start = mypool[0]->getVal();

      int stop = mypool[1]->getVal();

      int step  = mypool[2]->getVal();

      char* idx = new char[strlen(val)+1];

      if (start < 0)

        start = strlen(val) + start;

/////////////////////////////
        if (start < 0)

          start = 0;
      if (stop == INF)
        stop = strlen(val);
      else if (stop < 0)
        stop = strlen(val) + stop;
    if (stop < 0)
          stop = 0;
      int ind = 0;
      for (int i = start; i < stop; i+=step){
        idx[ind] = val[i];
        ind++;
      }
      idx[ind] = '\0';
      const Literal* node = new StrLiteral(idx);
      return node;
    }//////////////////////////////////////////////////////
  }
  virtual const Literal* opSlice(char* lhs) const {
    throw std::invalid_argument("TypeError: string indices must be integers, not str");
    return NULL;
  }

  float getVal() const {
    return -1.0 * INF;
  }
  std::string getType() const {
    std::string type = "str";
    return type;
  }

  virtual const Literal* eval() const { return this; }
  virtual void print() const { 
    std::cout << val << std::endl;;
  }
private:
  char* val;
};



///////////////////////////////////////////




class FloatLiteral: public Literal {
public:
  FloatLiteral(long double _val): val(_val) {}

  virtual const Literal* operator+(const Literal& rhs) const  {
    return rhs.opPlus(val);
  }
  virtual const Literal* opPlus(long double lhs) const  {
    const Literal* node = new FloatLiteral(lhs + val);
    PoolOfNodes::getInstance().add(node);
    return node; 
  }
  virtual const Literal* opPlus(int lhs) const  {
    const Literal* node = new FloatLiteral(lhs + val);
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opPlus(char* lhs) const  {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for +: 'float' and 'str'");
    return NULL;
  }
  virtual const Literal* operator-(const Literal& rhs) const  {
    return rhs.opSubt(val);
  }
  virtual const Literal* opSubt(long double lhs) const  {
    const Literal* node = new FloatLiteral(lhs - val);
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opSubt(int lhs) const  {
    const Literal* node = new FloatLiteral(lhs - val);
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opSubt(char* lhs) const  {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for -: 'float' and 'str'");
    return NULL;
  }

  virtual const Literal* operator*(const Literal& rhs) const  {
    return rhs.opMult(val);
  }
  virtual const Literal* opMult(long double lhs) const  {
    const Literal* node = new FloatLiteral(lhs * val);
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opMult(int lhs) const  {
    const Literal* node = new FloatLiteral(static_cast<long double>(lhs) * val);
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opMult(char* lhs) const  {
    throw std::invalid_argument("TypeError: can't multiply sequence by non-int of type 'float'");
    return NULL;
  }
  virtual const Literal* operator/(const Literal& rhs) const  {
    return rhs.opDiv(val);
  }
  virtual const Literal* opDiv(long double lhs) const  {
    if ( val == 0 ) throw std::string("Zero Division Error");
    const Literal* node = new FloatLiteral(lhs / val);
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opDiv(int lhs) const  {
    if ( val == 0 ) throw std::string("Zero Division Error");
    const Literal* node = new FloatLiteral(lhs / val);
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opDiv(char* lhs) const  {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for /: 'float' and 'str'");
    return NULL;
  }

  virtual const Literal* doubleStar(const Literal& rhs) const  {
    return rhs.opDStar(val);
  }
  virtual const Literal* opDStar(long double lhs) const  {
    const Literal* node = new FloatLiteral(pow(lhs,val));
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opDStar(int lhs) const  {
    const Literal* node = new FloatLiteral(pow(lhs,val));
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opDStar(char* lhs) const  {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for ** or pow(): 'float' and 'str'");
    return NULL;
  }

  virtual const Literal* operator%(const Literal& rhs) const  {
    return rhs.opPerc(val);
  }
  virtual const Literal* opPerc(long double lhs) const  {
    if ( val == 0 ) throw std::string("Zero Division Error");
    const Literal* node;
    if ( (fmod(lhs,val) == 0.0 ) && ((val < 0) || (lhs < 0)) )  
      node = new FloatLiteral(-fmod(lhs,val));
    else if ( ( lhs>0 && val<0 ) || ( lhs<0 && val>0) ) 
      node = new FloatLiteral(fmod(lhs,val) + val);
    else node = new FloatLiteral(fmod(lhs,val));
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opPerc(int lhs) const  {
    if ( val == 0 ) throw std::string("Zero Division Error");
    const Literal* node;
    if ( (fmod(lhs,val) == 0.0 ) && ((val < 0) || (lhs < 0)) )  
      node = new FloatLiteral(-fmod(lhs,val));
    else if ( ( lhs>0 && val<0 ) || ( lhs<0 && val>0) ) 
      node = new FloatLiteral(fmod(lhs,val) + val);
    else node = new FloatLiteral(fmod(lhs,val));
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opPerc(char* lhs) const  {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for %: 'float' and 'str'");
    return NULL;
  }
  virtual const Literal* doubleSlash(const Literal& rhs) const  {
    return rhs.opDSlash(val);
  }
  virtual const Literal* opDSlash(long double lhs) const  {
    if ( val == 0 ) throw std::string("Zero Division Error");
    const Literal* node = new FloatLiteral(std::floor(lhs / val));
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opDSlash(int lhs) const  {
    if ( val == 0 ) throw std::string("Zero Division Error");
    const Literal* node = new FloatLiteral(std::floor(lhs / val));
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opDSlash(char* lhs) const  {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for //: 'float' and 'str'");
    return NULL;
  }

  virtual const Literal* operator[](const Literal& rhs) const {
    return rhs.opSlice(val);
  }
  virtual const Literal* opSlice(long double lhs) const {
    throw std::invalid_argument("TypeError: 'float' object has no attribute '__getitem__'");
    return NULL;
  }
  virtual const Literal* opSlice(int lhs) const {
    throw std::invalid_argument("TypeError: 'float' object has no attribute '__getitem__'");
    return NULL;
  }
  virtual const Literal* opSlice(char* lhs) const {
    throw std::invalid_argument("TypeError: 'float' object has no attribute '__getitem__'");
    return NULL;
  }

  float getVal() const {
	return val;
  }
  std::string getType() const {
    std::string type = "float";
    return type;
  }

  virtual const Literal* eval() const { return this; }
  virtual void print() const { 
    if(fmod(val,1) == 0)
      std::cout << std::setprecision(12) << val << ".0" <<std::endl; 
    else
      std::cout << std::setprecision(12) << val << std::endl;  
  }
private:
  long double val;
};


////////////////////////////////////////////////




class IntLiteral: public Literal {
public:
  IntLiteral(int _val): val(_val) {}

  virtual const Literal* operator+(const Literal& rhs) const  {
    return rhs.opPlus(val);
  }
  virtual const Literal* opPlus(long double lhs) const  {
    const Literal* node = new FloatLiteral(static_cast<long double>(val) + lhs);
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opPlus(int lhs) const  {
    const Literal* node = new IntLiteral(lhs + val);
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opPlus(char* lhs) const  {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for +: 'int' and 'str'");
    return NULL;
  }


  virtual const Literal* operator-(const Literal& rhs) const  {
    return rhs.opSubt(val);
  }
  virtual const Literal* opSubt(long double lhs) const  {
    const Literal* node = new FloatLiteral(lhs - val);
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opSubt(int lhs) const  {
    const Literal* node = new IntLiteral(lhs - val);
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opSubt(char* lhs) const  {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for -: 'int' and 'str'");
    return NULL;
  }

  virtual const Literal* operator*(const Literal& rhs) const  {
    return rhs.opMult(val);
  }
  virtual const Literal* opMult(long double lhs) const  {
    const Literal* node = new FloatLiteral(lhs * val);
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opMult(int lhs) const  {
    const Literal* node = new IntLiteral(lhs * val);
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opMult(char* lhs) const  {
    char* cat = new char[strlen(lhs)*val+1];
    strcpy(cat,lhs);
    for (int i = 1; i < val; ++i){
      strcat(cat,lhs);
    }
    const Literal* node = new StrLiteral(cat);
    return node;
  }
  virtual const Literal* operator/(const Literal& rhs) const  {
    return rhs.opDiv(val);
  }
  virtual const Literal* opDiv(long double lhs) const  {
    if ( val == 0 ) throw std::string("Zero Division Error");
    const Literal* node = new FloatLiteral(lhs / val);
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opDiv(int lhs) const  {
    if ( val == 0 ) throw std::string("Zero Division Error");
    int tmp = lhs / val;
    if(( lhs>0 && val<0 ) || ( lhs<0 && val>0))
      tmp = tmp-1;
    const Literal* node = new IntLiteral(tmp);
    PoolOfNodes::getInstance().add(node);
    return node;
  }
 virtual const Literal* opDiv(char* lhs) const  {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for /: 'int' and 'str'");
    return NULL;
  }

  virtual const Literal* doubleStar(const Literal& rhs) const  {
    return rhs.opDStar(val);
  }
  virtual const Literal* opDStar(long double lhs) const  {
    const Literal* node = new FloatLiteral(pow(lhs,val));
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opDStar(int lhs) const  {
    const Literal* node;
    if ( val < 0 ) node = new FloatLiteral(pow(lhs,val));
    else node = new IntLiteral(pow(lhs,val));
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opDStar(char* lhs) const  {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for ** or pow(): 'int' and 'str'");
    return NULL;
  }

  virtual const Literal* operator%(const Literal& rhs) const  {
    return rhs.opPerc(val);
  }
  virtual const Literal* opPerc(long double lhs) const  {
    if ( val == 0 ) throw std::string("Zero Division Error");
    const Literal* node; 
    if ( (fmod(lhs,val) == 0.0 ) && ((val < 0) || (lhs < 0)) )  
      node = new FloatLiteral(-fmod(lhs,val));
    else if ( ( lhs>0 && val<0 ) || ( lhs<0 && val>0) ) 
      node = new FloatLiteral(fmod(lhs,val) + val);
    else node = new FloatLiteral(fmod(lhs,val));
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opPerc(int lhs) const  {
    if ( val == 0 ) throw std::string("Zero Division Error");
    const Literal* node;
    if ( ( lhs>0 && val<0 ) || ( lhs<0 && val>0) ) 
      node = new IntLiteral(fmod(lhs,val) + val); 
    else node = new IntLiteral(fmod(lhs,val));
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opPerc(char* lhs) const  {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for %: 'int' and 'str'");
    return NULL;
  }

  virtual const Literal* doubleSlash(const Literal& rhs) const  {
    return rhs.opDSlash(val);
  }
  virtual const Literal* opDSlash(long double lhs) const  {
    if ( val == 0 ) throw std::string("Zero Division Error");
    const Literal* node = new FloatLiteral(std::floor(lhs / val));
    PoolOfNodes::getInstance().add(node);
    return node;
  }
  virtual const Literal* opDSlash(int lhs) const  {
    return opDiv(lhs);
  }
  virtual const Literal* opDSlash(char* lhs) const  {
    throw std::invalid_argument("TypeError: unsupported operand type(s) for //: 'int' and 'str'");
    return NULL;
  }

  virtual const Literal* operator[](const Literal& rhs) const {
    return rhs.opSlice(val);
  }
  virtual const Literal* opSlice(long double lhs) const {
    throw std::invalid_argument("TypeError: 'int' object has no attribute '__getitem__'");
    return NULL;
  }
  virtual const Literal* opSlice(int lhs) const {
    throw std::invalid_argument("TypeError: 'int' object has no attribute '__getitem__'");
    return NULL;
  }
  virtual const Literal* opSlice(char* lhs) const {
    throw std::invalid_argument("TypeError: 'int' object has no attribute '__getitem__'");
    return NULL;
  }///////////////////////////

  float getVal() const {
    return (float)val;
  }
  std::string getType() const {
    std::string type = "int";
    return type;
  }


  virtual const Literal* eval() const { return this; }
  virtual void print() const { 
    std::cout << val << std::endl; 
  }
private:
  int val;
};

