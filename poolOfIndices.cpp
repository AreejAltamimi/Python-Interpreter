#include "node.h"
#include "poolOfIndices.h"

PoolOfIndices& PoolOfIndices::getInstance() {
  static PoolOfIndices iPool;
  return iPool;
}

void PoolOfIndices::clearThePool() {
	idxPool.clear();
}

std::vector<Literal*> PoolOfIndices::get() {
	std::vector<Literal*> idxPoolcp = idxPool;
	return idxPoolcp;
}

Literal* PoolOfIndices::rmv() {
	Literal* pop = idxPool.back();
	idxPool.pop_back();
	return pop;
}
