//PLAYER STAT
int power = 1;
int nBomb = 1;
int placedBomb = 0;
int life = 3;
int speed = 120;

final float PLAYER_TOUCHED_COOLDOWN = 3.0;

class Player {
  final int DIR_UP = 0;
  final int DIR_RIGHT = 1;
  final int DIR_DOWN = 2;
  final int DIR_LEFT = 3;

  boolean direction[] = new boolean[4];
  int lastPressedDirection = -1;
  boolean isMoving = false;
  float posX, posY;
  float touchedCooldown = 0;
  float destinationX, destinationY;
  Map map;

  Player(Map m) {
    map = m;
    posX = map.startX*TILE_SIZE;
    posY = map.startY*TILE_SIZE;
  }

  void process(float delta) {
    if (!isMoving) {
      tryStartMove();
    } else {
      moveTowardsDestination(delta);
    }
    if (touchedCooldown > 0) touchedCooldown-=delta;
  }

  void tryStartMove() {
    int tileX = int(posX / TILE_SIZE);
    int tileY = int(posY / TILE_SIZE);

    if (lastPressedDirection != -1) {
      if (direction[DIR_UP] && lastPressedDirection == DIR_UP && map.canMoveTo(tileX, tileY - 1)) {
        startMove(tileX, tileY - 1);
        lastPressedDirection = -1;
      } else if (direction[DIR_RIGHT] && lastPressedDirection == DIR_RIGHT && map.canMoveTo(tileX + 1, tileY)) {
        startMove(tileX + 1, tileY);
        lastPressedDirection = -1;
      } else if (direction[DIR_DOWN] && lastPressedDirection == DIR_DOWN && map.canMoveTo(tileX, tileY + 1)) {
        startMove(tileX, tileY + 1);
        lastPressedDirection = -1;
      } else if (direction[DIR_LEFT] && lastPressedDirection == DIR_LEFT && map.canMoveTo(tileX - 1, tileY)) {
        startMove(tileX - 1, tileY);
        lastPressedDirection = -1;
      }
    }

    if (isMoving == false && direction[DIR_UP] && map.canMoveTo(tileX, tileY - 1)) {
      startMove(tileX, tileY - 1);
    } else if (direction[DIR_RIGHT] && map.canMoveTo(tileX + 1, tileY)) {
      startMove(tileX + 1, tileY);
    } else if (direction[DIR_DOWN] && map.canMoveTo(tileX, tileY + 1)) {
      startMove(tileX, tileY + 1);
    } else if (direction[DIR_LEFT] && map.canMoveTo(tileX - 1, tileY)) {
      startMove(tileX - 1, tileY);
    }
  }

  void startMove(int destTileX, int destTileY) {
    destinationX = destTileX * TILE_SIZE;
    destinationY = destTileY * TILE_SIZE;
    isMoving = true;
  }

  void moveTowardsDestination(float delta) {
    float mvm = speed*delta;
    if(posX != destinationX){
      if(posX < destinationX){
        posX += mvm;
        if(posX > destinationX) posX = destinationX;
      }
      else{
        posX -= mvm;
        if(posX < destinationX) posX = destinationX;
      }
    }
    if(posY != destinationY){
      if(posY < destinationY){
        posY += mvm;
        if(posY > destinationY) posY = destinationY;
      }
      else{
        posY -= mvm;
        if(posY < destinationY) posY = destinationY;
      }
    }
    if(destinationX == posX && destinationY == posY){
      m.checkPlayerPosEvent();
      isMoving = false;
    }
  }
  

  int getPosX(){
    return int((posX+TILE_SIZE/2)/TILE_SIZE);
  }
  int getPosY(){
    return int((posY+TILE_SIZE/2)/TILE_SIZE);
  }

  void draw() {
    if (touchedCooldown <= 0 || int(touchedCooldown*4)%2 == 0) {
      fill(0, 0, 255);
      ellipse(posX+TILE_SIZE/2, posY+TILE_SIZE/2, TILE_SIZE/4*3, TILE_SIZE/4*3);
    }
  }

  void keyPressed(int k) {
    switch(k) {
    case 38:
      direction[DIR_UP] = true;
      lastPressedDirection = DIR_UP;
      break;
    case 39:
      direction[DIR_RIGHT] = true;
      lastPressedDirection = DIR_RIGHT;
      break;
    case 40:
      direction[DIR_DOWN] = true;
      lastPressedDirection = DIR_DOWN;
      break;
    case 37:
      direction[DIR_LEFT] = true;
      lastPressedDirection = DIR_LEFT;
      break;
    case 32:
      if ((placedBomb < nBomb && touchedCooldown <= 0 && !map.isThereBombAt(getPosX(), getPosY()) && map.placeBombAt(getPosX(), getPosY())))placedBomb++;
      break;//BOMB
    }
  }
  void keyReleased(int k) {
    switch(k) {
    case 38:
      direction[DIR_UP] = false;
      break;
    case 39:
      direction[DIR_RIGHT] = false;
      break;
    case 40:
      direction[DIR_DOWN] = false;
      break;
    case 37:
      direction[DIR_LEFT] = false;
      break;
    }
  }
}
