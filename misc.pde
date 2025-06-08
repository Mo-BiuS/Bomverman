boolean listContains(ArrayList<PVector> list, float x, float y) {
  for (PVector p : list) {
    if (p.x == x && p.y == y) return true;
  }
  return false;
}
void loadTexture() {
  imgPower = loadImage("Ressources/Item/BonusPower.png");
  imgNBomb = loadImage("Ressources/Item/BonusNBomb.png");
  imgSpeed = loadImage("Ressources/Item/BonusSpeed.png");
  imgLife  = loadImage("Ressources/Item/BonusLife.png");
  imgBomb  = loadImage("Ressources/Item/Bomb.png");

  imgTile = new ArrayList<PImage>();
  imgTile.add(loadImage("Ressources/Tile/Tile0.png"));
  imgTile.add(loadImage("Ressources/Tile/Tile1.png"));
  imgTile.add(loadImage("Ressources/Tile/Tile2.png"));
  imgTile.add(loadImage("Ressources/Tile/Tile3.png"));
  imgWall         = loadImage("Ressources/Tile/Wall.png");
  imgItemObstacle = loadImage("Ressources/Tile/ItemObstacle.png");
  imgObstacle     = loadImage("Ressources/Tile/Obstacle.png");
  imgEndDeasctivated = loadImage("Ressources/Tile/EndDesactivated.png");
  imgEndActivated    = loadImage("Ressources/Tile/EndActivated.png");
  
  imgHalfWall = loadImage("Ressources/Tile/HalfWall.png");;
  imgHalfObstacle = loadImage("Ressources/Tile/HalfObstacle.png");;
  imgHalfItemObstacle = loadImage("Ressources/Tile/HalfItemObstacle.png");
  
  slimeIdle = new PImage[4];
  slimeDown = new PImage[4];
  for(int i = 0; i < 4; i++){
    slimeIdle[i] = loadImage("Ressources/Charcter/Slime/Idle"+i+".png");
    slimeDown[i] = loadImage("Ressources/Charcter/Slime/Down"+i+".png");
  }
}
void drawBellow(int x, int y, Map map) {
  switch(map.m[x][y+1]) {
  case WALL:
    image(imgHalfWall, x * TILE_SIZE, (y+1) * TILE_SIZE-TILE_SIZE/4, TILE_SIZE, TILE_SIZE);
    break;
  case OBSTACLE:
    image(imgHalfObstacle, x * TILE_SIZE, (y+1) * TILE_SIZE-TILE_SIZE/4, TILE_SIZE, TILE_SIZE);
    break;
  case ITEM_OBSTACLE:
    image(imgHalfItemObstacle, x * TILE_SIZE, (y+1) * TILE_SIZE-TILE_SIZE/4, TILE_SIZE, TILE_SIZE);
    break;
  }
  //DEBUG
  //fill(0,0,0);rect(x * TILE_SIZE, (y+1) * TILE_SIZE-TILE_SIZE/4, TILE_SIZE, TILE_SIZE);
}
