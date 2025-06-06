final int BONUS_TYPE_POWER = 0;
final int BONUS_TYPE_NBOMB = 1;
final int BONUS_TYPE_SPEED = 2;
final int BONUS_TYPE_LIFE = 3;

final int WEIGHT_POWER = 4;
final int WEIGHT_NBOMB = 2;
final int WEIGHT_SPEED = 4;
final int WEIGHT_LIFE = 1;

class Bonus{
  int type;
  int posX,posY;
  
  Bonus(int px, int py){
    posX = px;
    posY = py;
    
    float r = random(WEIGHT_POWER+WEIGHT_NBOMB+WEIGHT_SPEED);
    if(r <= WEIGHT_POWER)type = BONUS_TYPE_POWER;
    else if(r <= WEIGHT_POWER+WEIGHT_NBOMB)type = BONUS_TYPE_NBOMB;
    else type = BONUS_TYPE_SPEED;
  }
  void draw(){
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
  }
}
