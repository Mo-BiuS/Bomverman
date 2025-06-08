boolean listContains(ArrayList<PVector> list, float x, float y) {
  for (PVector p : list) {
    if (p.x == x && p.y == y) return true;
  }
  return false;
}
void loadTexture(){
  imgPower = loadImage("Ressources/Item/BonusPower.png");
  imgNBomb = loadImage("Ressources/Item/BonusNBomb.png");
  imgSpeed = loadImage("Ressources/Item/BonusSpeed.png");
  imgLife  = loadImage("Ressources/Item/BonusLife.png");
  imgBomb  = loadImage("Ressources/Item/Bomb.png");
  
  imgTile     = loadImage("Ressources/Tile/Tile.png");
  imgObstacle = loadImage("Ressources/Tile/Obstacle.png");
}
