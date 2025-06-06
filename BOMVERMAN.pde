import java.util.Iterator;

final int TILE_SIZE = 64;

Map m;
Player p;

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
  p = new Player(m);
  m.p = p;
  
  lastTime = millis();
}

void draw(){
  deltaTime = (millis() - lastTime) / 1000.0;
  lastTime = millis();

  p.process(deltaTime);
  m.process(deltaTime);
    
  background(0);
  m.draw();
  m.drawBot();
  m.drawBonus();
  p.draw();
  m.drawBomb();
  drawStats();
}

void keyPressed(){
  p.keyPressed(keyCode);
}
void keyReleased(){
  p.keyReleased(keyCode);
}
