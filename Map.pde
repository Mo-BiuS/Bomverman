final int GROUND = 0;
final int WALL = 1;
final int OBSTACLE = 2;
final int ITEM_OBSTACLE = 8;
final int START = 4;
final int END = 5;

final int SUB_WALL = 8;
final float OBSTACLE_FILLING_RATIO = .4;
final float BONUS_RATIO = .8;
int nBot = 4;

class Map {
  final int START_RANGE = 1;

  ArrayList<Bomb> bombList = new ArrayList<Bomb>();
  ArrayList<Bonus> bonusList = new ArrayList<Bonus>();
  ArrayList<BasicBot> basicBotList = new ArrayList<BasicBot>();
  Player p;
  int[][] m;
  float[][] bombSplash;

  boolean canExitLevel = false;
  int sx, sy;
  int startX, startY;
  int endX, endY;

  Map(int sizeX, int sizeY) {
    sx = sizeX;
    sy = sizeY;
    reset();
  }

  void process(float delta) {
    p.process(delta);
    
    for (int i = 0; i < bombList.size(); i++)bombList.get(i).process(delta);
    for (int i = 0; i < basicBotList.size(); i++){
      BasicBot b = basicBotList.get(i);
      b.process(delta);
      if(p.touchedCooldown <= 0 && b.getPosX() == p.getPosX() && b.getPosY() == p.getPosY())playerDammage();
    }

    for (int x = 0; x < bombSplash.length; x++) {
      for (int y = 0; y < bombSplash[0].length; y++) {
        if (bombSplash[x][y] > 0)bombSplash[x][y] -= delta;
      }
    }
    
  }

  void draw() {
    for (int x = 0; x < m.length; x++) {
      for (int y = 0; y < m[0].length; y++) {
        switch(m[x][y]) {
        case GROUND:
          fill(255);
          break;
        case WALL:
          fill(0);
          break;
        case OBSTACLE:
          fill(100);
          break;
        case ITEM_OBSTACLE:
          fill(100, 92, 68);
          break;
        case START:
          fill(255);
          break;
        case END:
          if (canExitLevel)fill(0, 200, 0);
          else fill(255);
          break;
        }
        rect(x*TILE_SIZE, y*TILE_SIZE, TILE_SIZE, TILE_SIZE);
      }
    }
    fill(255, 0, 0);
    for (int x = 0; x < m.length; x++) {
      for (int y = 0; y < m[0].length; y++) {
        if (bombSplash[x][y] > 0) {
          rect(x*TILE_SIZE, y*TILE_SIZE, TILE_SIZE, TILE_SIZE);
        }
      }
    }
  }
  void drawBomb() {
    for (int i = 0; i < bombList.size(); i++)bombList.get(i).draw();
  }
  void drawBonus() {
    for (int i = 0; i < bonusList.size(); i++)bonusList.get(i).draw();
  }
  void drawBot() {
    for (int i = 0; i < basicBotList.size(); i++)basicBotList.get(i).draw();
  }
  void drawPlayer(){
    p.draw();
  }
  void exploseBomb(Bomb b) {
    if (bombList.contains(b))bombList.remove(b);
    for (int x = 0; x < bombSplash.length; x++) {
      for (int y = 0; y < bombSplash[0].length; y++) {
        if (bombSplash[x][y] > 0) {
          for (int i = 0; i < bombList.size(); i++) {
            if (bombList.get(i).posX == x && bombList.get(i).posY == y)bombList.get(i).explode();
          }
          if (p.touchedCooldown <= 0 && p.getPosX() == x && p.getPosY() == y) {
            playerDammage();
          }
          Iterator<BasicBot> it = basicBotList.iterator();
          while (it.hasNext()) {
            BasicBot bot = it.next();
            if (bot.getPosX() == x && bot.getPosY() == y) {
              it.remove(); // Sécurisé, pas d'erreur
            }
          }
          if (basicBotList.isEmpty())canExitLevel = true;
        }
      }
    }
  }

  void checkPlayerPosEvent() {
    if (canExitLevel && p.getPosX() == endX && p.getPosY() == endY) {
      level+=1;
      life+=1;
      reset();
    } else {
      for (int i = 0; i < bonusList.size(); i++) {
        Bonus b = bonusList.get(i);
        if (p.getPosX() == b.posX && p.getPosY() == b.posY) {
          switch(b.type) {
          case BONUS_TYPE_POWER:
            power+=1;
            break;
          case BONUS_TYPE_NBOMB:
            nBomb+=1;
            break;
          case BONUS_TYPE_SPEED:
            speed+=10;
            break;
          case BONUS_TYPE_LIFE:
            life+=1;
            break;
          }
          bonusList.remove(b);
        }
      }
    }
  }

  void playerDammage() {
    life--;
    if (life == 0) {
      nBot++;
      life = 3;
      power = 1;
      nBomb = 1;
      speed = 120;
      level = 1;
      reset();
    } else p.touchedCooldown = PLAYER_TOUCHED_COOLDOWN;
  }

  void reset() {

    m = new int[sx][sy];
    bombSplash = new float[sx][sy];
    bombList.clear();
    placedBomb = 0;
    bonusList.clear();
    basicBotList.clear();
    canExitLevel = false;

    //GEN BASE WALL
    int f = sx*sy;
    for (int x = 0; x < m.length; x++) {
      for (int y = 0; y < m[0].length; y++) {
        if ((x%2 == 0 && y %2 == 0) || (x == 0 || y == 0 || x == sx-1 || y == sy-1)) {
          m[x][y] = WALL;
          f--;
        }
      }
    }

    //GEN INNER WALL
    var s = SUB_WALL;
    while (s > 0) {
      int rx = int(random(sx));
      int ry = int(random(sy));
      if (m[rx][ry] != WALL && ((rx%2==0 && ry%2==1) || (rx%2==1 && ry%2==0)) && !doesGenWallAtCreateInaccessibleTile(rx, ry, f)) {
        m[rx][ry] = WALL;
        s--;
        f--;
      }
    }


    //GEN OBSTACLE
    int rp = 0;
    while (float(rp)/f < OBSTACLE_FILLING_RATIO) {
      int rx = int(random(sx));
      int ry = int(random(sy));
      if (m[rx][ry] == GROUND) {

        float item = random(1);

        if (item <= BONUS_RATIO)m[rx][ry] = ITEM_OBSTACLE;
        else m[rx][ry] = OBSTACLE;
        rp++;
      }
    }

    boolean foundStart = false;
    while (!foundStart) {
      int px = int(random(sx));
      int py = int(random(sy));
      if (m[px][py] == GROUND) {
        foundStart = true;
        m[px][py] = START;
        startX = char(px);
        startY = char(py);
      }
    }

    for (int x = startX-START_RANGE; x<=startX+START_RANGE; x++) {
      for (int y = startY-START_RANGE; y<=startY+START_RANGE; y++) {
        if (isIn(x, y) && (m[x][y] == OBSTACLE || m[x][y] == ITEM_OBSTACLE))m[x][y] = GROUND;
      }
    }

    //GEN END
    int ex = -1; //END X
    int ey = -1; //END Y
    float se = 0; //SCORE END
    for (int x = 0; x < m.length; x++) {
      for (int y = 0; y < m[0].length; y++) {
        if (m[x][y] != WALL) {
          float nse = sqrt(pow(x-startX, 2)+pow(y-startY, 2));//NEW SCORE END
          if (nse > se) {
            se = nse;
            ex = x;
            ey = y;
          }
        }
      }
    }
    endX = ex;
    endY = ey;
    m[ex][ey] = END;

    //loactePlayerArea
    ArrayList<PVector> playerStartArea = getPlayerStartArea(startX, startY);

    //GEN BOT
    int i = nBot;
    while (i > 0) {
      int px = int(random(sx));
      int py = int(random(sy));
      if (m[px][py] == GROUND && !listContains(playerStartArea, px, py)) {
        boolean noBotThere = true;
        for (BasicBot b : basicBotList) {
          noBotThere = noBotThere && !(b.getPosX() == px && b.getPosY() == py);
        }
        if (noBotThere) {
          basicBotList.add(new BasicBot(px*TILE_SIZE, py*TILE_SIZE, this));
          i--;
        }
      }
    }
    
    
    p = new Player(this);
  }

  boolean placeBombAt(int px, int py) {
    bombList.add(new Bomb(px, py, power, this));
    return true;
  }

  void spawnBonusAt(int px, int py) {
    bonusList.add(new Bonus(px, py));
  }

  boolean isThereBombAt(int px, int py) {
    for (int i = 0; i < bombList.size(); i++) {
      if (bombList.get(i).posX == px && bombList.get(i).posY == py)return true;
    }
    return false;
  }

  boolean isIn(int px, int py) {
    return px >= 0 && py >= 0 && px < m.length && py < m[0].length;
  }
  boolean canMoveTo(int px, int py) {
    return isIn(px, py) && !(m[px][py] == WALL || m[px][py] == OBSTACLE || m[px][py] == ITEM_OBSTACLE) && !isThereBombAt(px, py);
  }

  boolean isTileColliding(int px, int py) {
    return !isIn(px, py) || !(m[px][py] == GROUND);
  }

  boolean doesGenWallAtCreateInaccessibleTile(int rx, int ry, int f) {
    m[rx][ry] = WALL;
    int i = propagate(rx, ry);
    return i == f-1;
  }
  int propagate(int rx, int ry) {
    if (m[rx][ry] == WALL || m[rx][ry] == -1)return 0;
    else {
      m[rx][ry] = -1;
      int rep = 1;
      rep+=propagate(rx+1, ry);
      rep+=propagate(rx-1, ry);
      rep+=propagate(rx, ry+1);
      rep+=propagate(rx, ry-1);
      m[rx][ry] = GROUND;
      return rep;
    }
  }
  ArrayList<PVector> getPlayerStartArea(int startX, int startY) {
    if (m[startX][startY] == GROUND || m[startX][startY] == START) {
      ArrayList<PVector> rep = new ArrayList<PVector>();
      rep.add(new PVector(startX, startY));

      boolean g = m[startX][startY] == GROUND;

      m[startX][startY] = -1;

      rep.addAll(getPlayerStartArea(startX-1, startY));
      rep.addAll(getPlayerStartArea(startX+1, startY));
      rep.addAll(getPlayerStartArea(startX, startY-1));
      rep.addAll(getPlayerStartArea(startX, startY+1));

      if (g)m[startX][startY] = GROUND;
      else m[startX][startY] = START;

      return rep;
    } else return new ArrayList<PVector>();
  }
}
