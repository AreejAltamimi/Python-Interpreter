#include <vector>
class Node;

class PoolOfIndices {
public:
  static PoolOfIndices& getInstance();
  void add(Literal* idx) { idxPool.push_back(idx); }
  Literal* rmv();
  std::vector<Literal*> get();
  void clearThePool();
private:
  std::vector<Literal*> idxPool;
  PoolOfIndices() : idxPool() {}
};
