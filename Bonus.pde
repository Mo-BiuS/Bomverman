final int BONUS_TYPE_POWER = 0;
final int BONUS_TYPE_NBOMB = 1;
final int BONUS_TYPE_SPEED = 2;
final int BONUS_TYPE_LIFE  = 3;

final float WEIGHT_POWER = 6;
final float WEIGHT_NBOMB = 2;
final float WEIGHT_SPEED = 4;
final float WEIGHT_LIFE  = 1;

PImage imgPower;
PImage imgNBomb;
PImage imgSpeed;
PImage imgLife;

class Bonus{
  int type;
  int posX,posY;
  Map map;
  
  Bonus(int px, int py, Map m){
    posX = px;
    posY = py;
    map = m;
    
    float r = random(WEIGHT_POWER+WEIGHT_NBOMB+WEIGHT_SPEED);
    if(r <= WEIGHT_POWER)type = BONUS_TYPE_POWER;
    else if(r <= WEIGHT_POWER+WEIGHT_NBOMB)type = BONUS_TYPE_NBOMB;
    else if(r <= WEIGHT_POWER+WEIGHT_NBOMB+WEIGHT_SPEED)type = BONUS_TYPE_SPEED;
    else type = BONUS_TYPE_LIFE;
  }
  void draw(){
    
    //IMAGE
    switch(type){
      case BONUS_TYPE_POWER: image(imgPower, posX * TILE_SIZE, posY * TILE_SIZE,TILE_SIZE,TILE_SIZE);break;
      case BONUS_TYPE_NBOMB: image(imgNBomb, posX * TILE_SIZE, posY * TILE_SIZE,TILE_SIZE,TILE_SIZE);break;
      case BONUS_TYPE_SPEED: image(imgSpeed, posX * TILE_SIZE, posY * TILE_SIZE,TILE_SIZE,TILE_SIZE);break;
      case BONUS_TYPE_LIFE : image(imgLife, posX * TILE_SIZE, posY * TILE_SIZE,TILE_SIZE,TILE_SIZE);break;
    }
    drawBellow(posX,posY,map);
    
    /* DRAWING
    switch(type){
      case BONUS_TYPE_POWER: fill(128,0,128);break;
      case BONUS_TYPE_NBOMB: fill(255,127,0);break;
      case BONUS_TYPE_SPEED: fill(0,0,255);break;
      case BONUS_TYPE_LIFE: fill(0,255,0);break;
    }
    
    int x = posX * TILE_SIZE;
    int y = posY * TILE_SIZE;
    int half = TILE_SIZE / 2;
    int quarter = TILE_SIZE / 4;
    int three_quarter = TILE_SIZE - quarter;

    quad(
        x + half,         y + quarter,        // Haut
        x + three_quarter, y + half,          // Droite
        x + half,         y + three_quarter,  // Bas
        x + quarter,      y + half            // Gauche
        );
    */
  }
}
