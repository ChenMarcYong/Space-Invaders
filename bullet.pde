class Bullet {
  //position on screen
  PVector _position;
  //position on board
  int _cellX = -1, _cellY = -1;
  //direction up if it's a spaceship bullet or down if it's an invader bullet
  PVector _direction;
  //if the bullet is already shot or not
  boolean _isMoving;
  // bullet speed on screen
  int bullet_speed = 10;
  Bullet(PVector pos, PVector dir) {
    _position = pos.copy();
    _direction = dir.copy();
    _isMoving = false;
    update();
  }
  void move() {
    if (_isMoving == false ) {
      return;
    }
    _position.y += _direction.y*bullet_speed ;
    if ((board._cells[_cellY][_cellX] == TypeCell.INVADER)&&(_direction.y < 0)) {
      destroy();
      total_score += SCORE_KILL;
      _position.set(-50, -50);
      _isMoving = false;
    } else if ((board._cells[_cellY][_cellX] == TypeCell.SPACESHIP)&&(_direction.y > 0)) {
      destroy_spaceship();
      _position.set(-50, -50);
      _isMoving = false;
    } else if (_position.y < board._position.y) {
      _position.set(-50, -50);
      _isMoving = false;
    } else if ((_position.y < (board._position.y + (board._nbCellsY*board._cellSize)))&&
      (_position.y > (board._position.y + (board._nbCellsY*board._cellSize) ) - 12)) {
      _position.set(-50, -50);
      _isMoving = false;
    } else if (board._cells[_cellY][_cellX] == TypeCell.OBSTACLE) {
      _position.set(-50, -50);
      _isMoving = false;
    }
    update();
  }
  //update the position of the bullet on the board
  void update() {
    int x = floor((_position.x - board._position.x) / board._cellSize);
    int y = floor((_position.y - board._position.y) / board._cellSize);
    if (_cellY != y) {
      _cellY = y;
    }
    if (_cellX != x) {
      _cellX = x;
    }
  }
  // destroy an invader and end the game if all invaders are destroyed
  void destroy() {
    if (_direction.y > 0) {
      return;
    }
    board._cells[_cellY][_cellX] = TypeCell.EMPTY ;
    for (int i = 0; i < enemies.invaders.length; i++) {
      if ((enemies.invaders[i]._cellX == _cellX)&&(enemies.invaders[i]._cellY == _cellY)) {
        if (enemies.nbInvaders == 1) {
          game._score+=100*game._lives;
          levels.score_=game._score;
          game_state="fin_level";                                                                            // fin_niveau.
        }
        enemies.invaders[i].drop_bonus();
        enemies.removeByIndex(i);
        enemies.nbInvaders -- ;
      }
    }
    for (int i = 0; i < enemies.invaders.length; i++) {
      enemies.invaders[i].set_relative();
    }
    game._score += (game._multiplier*SCORE_KILL);                                                                              //destroy.
  }
  // take off a life of the spaceship and end the game if there is no lives left
  void destroy_spaceship() {
    game._lives --;
    rectMode(CORNER);
    fill(255, 0, 0);                                                                   // animation de perdre 1 pv.
    //Sound.spaceship_hit() ;
    rect(0, 0, width, height);
    if (game._lives <= 0) {
      save_score();
      highscore();
      Sound.game_over();
      game_state="loose_game";        
      in_game_music.stop();                                                      //game_over.
    }
  }
  void drawIt() {
    fill(255);
    rectMode(CENTER);
    rect(_position.x, _position.y, 10, 10);
  }
}

// get an array of bullets that can be shot by the spaceship
Bullet[] settSSBullets(int number_of_bullets) {
  Bullet[] b = new Bullet[ number_of_bullets];
  for (int i = 0; i < number_of_bullets; ++i) {
    b[i] = new Bullet(new PVector(-50, -50), new PVector(0, -1));
  }
  return b;
}
// get an array of bullets that can be shot by the invaders
Bullet[] settEnemiesBullets(int number_of_bullets) {
  Bullet[] b = new Bullet[ number_of_bullets];
  for (int i = 0; i < number_of_bullets; ++i) {
    b[i] = new Bullet(new PVector(-50, -50), new PVector(0, 1));
  }
  return b;
}
