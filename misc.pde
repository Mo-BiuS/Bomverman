boolean listContains(ArrayList<PVector> list, float x, float y) {
  for (PVector p : list) {
    if (p.x == x && p.y == y) return true;
  }
  return false;
}
void loadTexture(){
  imgPower = loadImage("Ressources/Bonus/BonusPower.png");
  imgNBomb = loadImage("Ressources/Bonus/BonusNBomb.png");
  imgSpeed = loadImage("Ressources/BonusSpeed.png");
  imgLife  = loadImage("Ressources/Bonus/BonusLife.png");
}
