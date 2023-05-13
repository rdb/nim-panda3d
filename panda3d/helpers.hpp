#pragma once

#include "pointerTo.h"

template<class T> PT(T) deconstify(CPT(T) value) {
  PT(T) result;
  result.cheat() = (T *)value.p();
  value.cheat() = nullptr;
  return result;
}

template<class T> T *deconstify(const T *value) {
  return (T *)value;
}
