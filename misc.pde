import java.util.LinkedList;

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
  slimeUp = new PImage[4];
  slimeRight = new PImage[4];
  slimeDown = new PImage[4];
  slimeLeft = new PImage[4];
  for(int i = 0; i < 4; i++){
    slimeIdle[i]  = loadImage("Ressources/Charcter/Slime/Idle"+i+".png");
    slimeRight[i] = loadImage("Ressources/Charcter/Slime/Right"+i+".png");
    slimeUp[i]    = loadImage("Ressources/Charcter/Slime/Up"+i+".png");
    slimeDown[i]  = loadImage("Ressources/Charcter/Slime/Down"+i+".png");
    slimeLeft[i]  = loadImage("Ressources/Charcter/Slime/Left"+i+".png");
  }
  
  playerUp = new PImage[4];
  playerRight = new PImage[4];
  playerDown = new PImage[4];
  playerLeft = new PImage[4];
  for(int i = 0; i < 4; i++){
    playerUp[i]   = loadImage("Ressources/Charcter/Player/Up"+i+".png");
    playerRight[i]   = loadImage("Ressources/Charcter/Player/Right"+i+".png");
    playerDown[i] = loadImage("Ressources/Charcter/Player/Down"+i+".png");
    playerLeft[i]   = loadImage("Ressources/Charcter/Player/Left"+i+".png");
  }
  
  imgExplosionCorner = new PImage[2];
  imgExplosionEnd    = new PImage[2];
  imgExplosionLine   = new PImage[2];
  imgExplosionSolo   = new PImage[2];
  imgExplosionCenter = new PImage[2];
  imgExplosionT      = new PImage[2];
  for(int i = 0; i < 2; i++){
  imgExplosionCorner[i] = loadImage("Ressources/ElectricExplosion/corner"+i+".png");
  imgExplosionEnd[i]    = loadImage("Ressources/ElectricExplosion/end"+i+".png");
  imgExplosionLine[i]   = loadImage("Ressources/ElectricExplosion/Line"+i+".png");
  imgExplosionSolo[i]   = loadImage("Ressources/ElectricExplosion/Solo"+i+".png");
  imgExplosionCenter[i] = loadImage("Ressources/ElectricExplosion/X"+i+".png");
  imgExplosionT[i]      = loadImage("Ressources/ElectricExplosion/T"+i+".png");
    
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
boolean isCut(int[][] map, int x, int y) {
  if (map[x][y] != GROUND) return false;

  int w = map.length;
  int h = map[0].length;
  
  int[][] temp = new int[w][h];
  int totalGround = 0;
  for (int i = 0; i < w; i++) {
    for (int j = 0; j < h; j++) {
      temp[i][j] = map[i][j];
      if (temp[i][j] == GROUND) totalGround++;
    }
  }
  
  temp[x][y] = WALL;
  totalGround--;

  int startX = -1, startY = -1;
  outer:
  for (int i = 0; i < w; i++) {
    for (int j = 0; j < h; j++) {
      if (temp[i][j] == GROUND) {
        startX = i;
        startY = j;
        break outer;
      }
    }
  }

  if (startX == -1) return false;

  boolean[][] visited = new boolean[w][h];
  LinkedList<int[]> queue = new LinkedList<>();
  queue.add(new int[]{startX, startY});
  visited[startX][startY] = true;
  int count = 1;

  int[][] dirs = {{1,0},{-1,0},{0,1},{0,-1}};
  while (!queue.isEmpty()) {
    int[] current = queue.poll();
    for (int[] dir : dirs) {
      int nx = current[0] + dir[0];
      int ny = current[1] + dir[1];
      if (nx >= 0 && ny >= 0 && nx < w && ny < h) {
        if (!visited[nx][ny] && temp[nx][ny] == GROUND) {
          visited[nx][ny] = true;
          queue.add(new int[]{nx, ny});
          count++;
        }
      }
    }
  }

  return count < totalGround;
}
