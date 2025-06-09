import java.util.Iterator;

final int TILE_SIZE = 64;

Map m;

int level = 1;
int lastTime = 0;
float deltaTime = 0;

float resetTime = 2;
float timer;

void setup(){
  size(960,1040);
  noStroke();
  frameRate(120);
  PFont mono = createFont("Ressources/FSEX300.ttf", 32);
  textFont(mono);
    
  loadTexture();
  m = new Map(15,15);

  
  lastTime = millis();
}

void draw(){
  deltaTime = (millis() - lastTime) / 1000.0;
  lastTime = millis();

  /*timer+=deltaTime;
  if(timer > resetTime){
    timer = 0;
    m.reset();
  }*/

  m.process(deltaTime);
  
  
    
  background(0);
  translate(0,TILE_SIZE/4);
  m.draw();
  m.drawBot();
  m.drawBonus();
  m.drawPlayer();
  m.drawBomb();
  m.drawExplosion();
  translate(0,-TILE_SIZE/4);
  drawStats();
}

void keyPressed(){
  m.p.keyPressed(keyCode);
}
void keyReleased(){
  m.p.keyReleased(keyCode);
}
