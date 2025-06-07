import java.util.Iterator;

final int TILE_SIZE = 64;

Map m;

int level = 1;
int lastTime = 0;
float deltaTime = 0;

void setup(){
  size(960,1024);
  noStroke();
  frameRate(120);
  PFont mono = createFont("FSEX300.ttf", 32);
  textFont(mono);
  
  m = new Map(15,15);
  
  loadTexture();
  
  lastTime = millis();
}

void draw(){
  deltaTime = (millis() - lastTime) / 1000.0;
  lastTime = millis();

  m.process(deltaTime);
    
  background(0);
  m.draw();
  m.drawBot();
  m.drawBonus();
  m.drawPlayer();
  m.drawBomb();
  drawStats();
}

void keyPressed(){
  m.p.keyPressed(keyCode);
}
void keyReleased(){
  m.p.keyReleased(keyCode);
}
