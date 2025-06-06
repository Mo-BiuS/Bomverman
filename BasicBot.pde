class BasicBot{
  int posX, posY;
  int destX, destY;
  int botSpeed = 120;
  int lastDirection;
  Map map;
  boolean isMoving;
  
  BasicBot(int px, int py, Map m){
    map = m;
    posX = px;
    posY = py;
    isMoving = false;
    lastDirection = -1;
  }
  
  void draw(){
      fill(255, 0, 0);
      ellipse(posX+TILE_SIZE/2, posY+TILE_SIZE/2, TILE_SIZE/2, TILE_SIZE/2);
  }
  
  void process(float delta){
    if (!isMoving) {
      tryStartMove();
    } else {
      moveTowardsDestination(delta);
    }
  }
  
  void tryStartMove(){
    destX = posX;
    destY = posY;
    Integer n = 0;
    Integer e = 1;
    Integer s = 2;
    Integer w = 3;
    ArrayList<Integer> validDirection = new ArrayList<Integer>();
    if(map.canMoveTo(getPosX(),getPosY()-1))validDirection.add(n);
    if(map.canMoveTo(getPosX()+1,getPosY()))validDirection.add(e);
    if(map.canMoveTo(getPosX(),getPosY()+1))validDirection.add(s);
    if(map.canMoveTo(getPosX()-1,getPosY()))validDirection.add(w);
    
    if(validDirection.size() > 0){
      if(validDirection.size() > 1){
        switch(lastDirection){
          case 0:validDirection.remove(s);break;
          case 1:validDirection.remove(w);break;
          case 2:validDirection.remove(n);break;
          case 3:validDirection.remove(e);break;
        }
      }
      int direction = validDirection.get(int(random(validDirection.size())));
      switch(direction){
        case 0:destY-=TILE_SIZE;lastDirection = 0;break;
        case 1:destX+=TILE_SIZE;lastDirection = 1;break;
        case 2:destY+=TILE_SIZE;lastDirection = 2;break;
        case 3:destX-=TILE_SIZE;lastDirection = 3;break;
      }
      isMoving = true;
    }
  }
  
  //YAY MAGIC NUMBER
  void moveTowardsDestination(float delta) {
    float mvm = botSpeed*delta;
    if(posX != destX){
      if(posX < destX){
        posX += mvm*1.2;
        if(posX > destX) posX = destX;
      }
      else{
        posX -= mvm*.8;
        if(posX < destX) posX = destX;
      }
    }
    if(posY != destY){
      if(posY < destY){
        posY += mvm*1.2;
        if(posY > destY) posY = destY;
      }
      else{
        posY -= mvm*.8;
        if(posY < destY) posY = destY;
      }
    }
    if(destX == posX && destY == posY)isMoving = false;
  }
  
  int getPosX(){
    return int((posX+TILE_SIZE/2)/TILE_SIZE);
  }
  int getPosY(){
    return int((posY+TILE_SIZE/2)/TILE_SIZE);
  }
}
