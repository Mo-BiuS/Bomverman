boolean listContains(ArrayList<PVector> list, float x, float y) {
  for (PVector p : list) {
    if (p.x == x && p.y == y) return true;
  }
  return false;
}
