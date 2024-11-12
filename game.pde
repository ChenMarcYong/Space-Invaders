class Game
{
  String _levelName;
  int _lives=3;
  int _score;
  int _multiplier = 1;
  int _fireRate_reduction = 1;
  String _profile;
  boolean _left, _right, _shoot;

  Game(String level, String profile) {
    _levelName = level;
    _profile = profile;
  }




  void update() {
  }

  void drawIt() {
    board.drawIt();
    enemies.drawIt();
    ship.drawIt();
    bonus.drawIt();
    for (int i = 0; i < 100; ++i) {
      ss_bullets[i].drawIt();
      enemies_bullets[i].drawIt();
    }
  }
  void moves() {
    enemies.move();
    bonus.move();
    enemies.shoot();
    ship.interpolate();

    bonus.apply();
    for (int i = 0; i < 100; ++i) {
      ss_bullets[i].move();
      enemies_bullets[i].move();
    }
  }

  void handleKey() {
    if (_right == true) {
      ship.move("RIGHT");
    }
    if (_left == true) {
      ship.move("LEFT");
    }
    if (_shoot == true) {
      ship.shoot();
    }
  }
}

void initGame(String level) {
  game = new Game("level1", "");
  board = initBoard(level);
  ship = initSpaceship();
  ss_bullets = settSSBullets(100);
  enemies_bullets = settEnemiesBullets(100);
  enemies = new Invaders();
  bonus = new Bonus();
}
