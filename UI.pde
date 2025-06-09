void drawStats(){
  textAlign(CENTER,CENTER);
  textSize(32);
  
  fill(128,0,128);
  text("Power:" + power, 1024/6*1-32, 1008);
  fill(255,127,0);
  text("NBomb:" + placedBomb+"/"+nBomb, 1024/6*2-32, 1008);
  fill(0,255,0);
  text("Life:" + life, 1024/6*3-32, 1008);
  fill(0,0,255);
  text("Speed:" + float(speed)/100, 1024/6*4-32, 1008);
  fill(255);
  text("Level:" + level, 1024/6*5-32, 1008);
  
  /*textAlign(CORNER,CENTER);
  textSize(32);
  text("FPS:"+int(frameRate), 64,32);*/
}
