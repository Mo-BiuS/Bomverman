//PLAYER STAT
int power = 1;
int nBomb = 1;
int placedBomb = 0;
int life = 3;
int speed = 120;

PImage[] playerUp;
PImage[] playerRight;
PImage[] playerDown;
PImage[] playerLeft;

final float PLAYER_TOUCHED_COOLDOWN = 3.0;

class Player {
  final int DIR_UP = 0;
  final int DIR_RIGHT = 1;
  final int DIR_DOWN = 2;
  final int DIR_LEFT = 3;
  
  final float ANIM_DURATION = .2;
  float animationTime;

  boolean direction[] = new boolean[4];
  int lastPressedDirection = -1;
  boolean isMoving = false;
  float posX, posY;
  float touchedCooldown = 0;
  float destinationX, destinationY;
  Map map;

  int actualDirection;

  Player(Map m) {
    actualDirection=DIR_DOWN;
    map = m;
    posX = map.startX*TILE_SIZE;
    posY = map.startY*TILE_SIZE;
  }

  void process(float delta) {
    animationTime+=delta*speed/100;
    if(animationTime >= ANIM_DURATION*4)animationTime = 0;
    if (isMoving) moveTowardsDestination(delta);
    if (!isMoving)tryStartMove();
    if (touchedCooldown > 0) touchedCooldown-=delta;
    if(touchedCooldown <= 0 && map.bombSplash[int((posX+TILE_SIZE/2)/TILE_SIZE)][int((posY+TILE_SIZE/2)/TILE_SIZE)] > 0)map.playerDammage();
  }
  
  void draw() {
    if (touchedCooldown <= 0 || int(touchedCooldown*4)%2 == 0) {

      if(!isMoving){
        switch(actualDirection){
          case DIR_UP:
          image(playerUp[0],posX,posY-TILE_SIZE/4,TILE_SIZE,TILE_SIZE+TILE_SIZE/4);
          break;
          case DIR_RIGHT:
          image(playerRight[0],posX,posY-TILE_SIZE/4,TILE_SIZE,TILE_SIZE+TILE_SIZE/4);
          break;
          case DIR_DOWN:
          image(playerDown[0],posX,posY-TILE_SIZE/4,TILE_SIZE,TILE_SIZE+TILE_SIZE/4);
          break;
          case DIR_LEFT: 
          image(playerLeft[0],posX,posY-TILE_SIZE/4,TILE_SIZE,TILE_SIZE+TILE_SIZE/4);
          break;
        }
        
        drawBellow(int(posX/TILE_SIZE),int(posY/TILE_SIZE),map);
      }
      else{
        switch(actualDirection){
          case DIR_UP:
          image(playerUp[int(animationTime/ANIM_DURATION)],posX,posY-TILE_SIZE/4,TILE_SIZE,TILE_SIZE+TILE_SIZE/4);
          drawBellow(int(posX/TILE_SIZE),int((posY-1)/TILE_SIZE)+1,map);
          break;
          case DIR_RIGHT:
          image(playerRight[int(animationTime/ANIM_DURATION)],posX,posY-TILE_SIZE/4,TILE_SIZE,TILE_SIZE+TILE_SIZE/4);
          drawBellow(int(posX/TILE_SIZE),int(posY/TILE_SIZE),map);
          drawBellow(int(posX/TILE_SIZE)+1,int(posY/TILE_SIZE),map);
          break;
          case DIR_DOWN:
          image(playerDown[int(animationTime/ANIM_DURATION)],posX,posY-TILE_SIZE/4,TILE_SIZE,TILE_SIZE+TILE_SIZE/4);
          drawBellow(int(posX/TILE_SIZE),int(posY/TILE_SIZE)+1,map);
          break;
          case DIR_LEFT: 
          image(playerLeft[int(animationTime/ANIM_DURATION)],posX,posY-TILE_SIZE/4,TILE_SIZE,TILE_SIZE+TILE_SIZE/4);
          drawBellow(int(posX/TILE_SIZE),int(posY/TILE_SIZE),map);
          drawBellow(int((posX-1)/TILE_SIZE)+1,int(posY/TILE_SIZE),map);
          break;
        }
      }
    }
  }
  
  void tryStartMove() {
    int tileX = int(posX / TILE_SIZE);
    int tileY = int(posY / TILE_SIZE);

    if (lastPressedDirection != -1) {
      if (direction[DIR_UP] && lastPressedDirection == DIR_UP && map.canMoveTo(tileX, tileY - 1)) {
        startMove(tileX, tileY - 1);
        lastPressedDirection = -1;
        actualDirection = DIR_UP;
      } else if (direction[DIR_RIGHT] && lastPressedDirection == DIR_RIGHT && map.canMoveTo(tileX + 1, tileY)) {
        startMove(tileX + 1, tileY);
        lastPressedDirection = -1;
        actualDirection = DIR_RIGHT;
      } else if (direction[DIR_DOWN] && lastPressedDirection == DIR_DOWN && map.canMoveTo(tileX, tileY + 1)) {
        startMove(tileX, tileY + 1);
        lastPressedDirection = -1;
        actualDirection = DIR_DOWN;
      } else if (direction[DIR_LEFT] && lastPressedDirection == DIR_LEFT && map.canMoveTo(tileX - 1, tileY)) {
        startMove(tileX - 1, tileY);
        lastPressedDirection = -1;
        actualDirection = DIR_LEFT;
      }
    }

    if (isMoving == false && direction[DIR_UP] && map.canMoveTo(tileX, tileY - 1)) {
      startMove(tileX, tileY - 1);
      actualDirection = DIR_UP;
    } else if (direction[DIR_RIGHT] && map.canMoveTo(tileX + 1, tileY)) {
      startMove(tileX + 1, tileY);
      actualDirection = DIR_RIGHT;
    } else if (direction[DIR_DOWN] && map.canMoveTo(tileX, tileY + 1)) {
      startMove(tileX, tileY + 1);
      actualDirection = DIR_DOWN;
    } else if (direction[DIR_LEFT] && map.canMoveTo(tileX - 1, tileY)) {
      startMove(tileX - 1, tileY);
      actualDirection = DIR_LEFT;
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
