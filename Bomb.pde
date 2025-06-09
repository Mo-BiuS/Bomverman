final float bombTimer = 3;
final float explosionDuration = .8;

PImage imgBomb;

class Bomb{
  int posX, posY;
  int bombPower;
  float timer = 0;
  Map map;
  
  Bomb(int px, int py, int p, Map m){
    posX = px;
    posY = py;
    bombPower = p;
    map = m;
  }
  
  void process(float delta){
    timer+=delta;
    if(timer > bombTimer)explode();
  }
  
  void explode(){
    placedBomb--;
    propagateExplosion(posX, posY, bombPower,-1);
    map.exploseBomb(this);
  }
  
  void propagateExplosion(int px, int py, int p, int direction){
    if(map.isIn(px,py)){
      map.bombSplash[px][py] = explosionDuration;
      
      if(map.m[px][py] == OBSTACLE)map.m[px][py] = GROUND;
      else if(map.m[px][py] == ITEM_OBSTACLE){
        map.m[px][py] = GROUND;
        map.spawnBonusAt(px,py);
      }
      else if(p>0){
        if(map.isIn(px-1,py) && (direction == -1 || direction == 0) && map.m[px-1][py] != WALL)propagateExplosion(px-1,py,p-1,0);
        if(map.isIn(px+1,py) && (direction == -1 || direction == 1) && map.m[px+1][py] != WALL)propagateExplosion(px+1,py,p-1,1);
        if(map.isIn(px,py-1) && (direction == -1 || direction == 2) && map.m[px][py-1] != WALL)propagateExplosion(px,py-1,p-1,2);
        if(map.isIn(px,py+1) && (direction == -1 || direction == 3) && map.m[px][py+1] != WALL)propagateExplosion(px,py+1,p-1,3);
      }
    }
  }
  
  void draw(){
    image(imgBomb, posX * TILE_SIZE, posY * TILE_SIZE,TILE_SIZE,TILE_SIZE);
    drawBellow(posX,posY,map);
    /*
    fill(128,0,128);
    ellipse(posX*TILE_SIZE+TILE_SIZE/2,posY*TILE_SIZE+TILE_SIZE/2,TILE_SIZE/2,TILE_SIZE/2);
    */
  }
}
