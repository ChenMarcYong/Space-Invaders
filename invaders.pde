class Invaders {
  // group all enemies on an array
  Enemy[] invaders;
  //number of enemies
  int nbInvaders = 0;
  // direction of moving enemies
  String direction = "LEFT";
  // invaders movement speed
  int invaders_mvt_speed = 1000;
  // invaders lassst movement
  int invaders_last_move = millis();
  //invaders shooting data
  int invaders_last_shot = millis();
  int invaders_fire_rate = 500;
  PImage invader=loadImage("sprite/e2.png");
  Invaders() {
    init_invaders();
  }
  // initiat the object Invaders
  void init_invaders() {
    for (int i = 0; i < board._cells.length; ++i) {
      for (int j = 0; j < board._cells[i].length; ++j) {
        if (board._cells[i][j] == TypeCell.INVADER) {
          nbInvaders ++;
        }
      }
    }
    invaders = new Enemy[nbInvaders];
    int id = 0;
    for (int i = 0; i < board._cells.length; ++i) {
      for (int j = 0; j < board._cells[i].length; ++j) {
        if (board._cells[i][j] == TypeCell.INVADER) {
          invaders[id] = new Enemy(j, i);
          id++;
        }
      }
    }
  }
  // set the direction of the invaders movement
  void setDirection() {
    if ((right_edge() == false) && (left_edge() == false )) {
      return;
    }
    if ((direction == "LEFT") && (left_edge() == true)) {
      direction = "DOWN";
    } else if ((direction == "DOWN") && (left_edge() == true)) {
      direction = "RIGHT";
    } else if ((direction == "RIGHT") && (right_edge() == true)) {
      direction = "DOWN";
    } else if ((direction == "DOWN") && (right_edge() == true)) {
      direction = "LEFT";
    }
  }
  void move() {
    if (millis() - invaders_last_move < invaders_mvt_speed) {
      return;
    }
    setDirection();
    if (direction == "NONE") {
      return;
    }
    for (int i = 0; i < invaders.length; ++i) {
      if (direction == "LEFT") {
        invaders[i]._cellX --;
        invaders[i]._position = board.getCellCenter(invaders[i]._cellY, invaders[i]._cellX).copy();
      } else if (direction == "RIGHT") {
        invaders[i]._cellX ++;
        invaders[i]._position = board.getCellCenter(invaders[i]._cellY, invaders[i]._cellX).copy();
      } else if (direction == "DOWN") {
        invaders[i]._cellY ++;
        invaders[i]._position = board.getCellCenter(invaders[i]._cellY, invaders[i]._cellX).copy();
      }
    }
    invaders_last_move = millis();
    land_edge();
    update();
  }
  // update the position of the invaders on the board
  void update() {
    if (direction == "NONE") {
      return;
    }
    for (int i = 0; i < board._cells.length; ++i) {
      for (int j = 0; j < board._cells[i].length; ++j) {
        if (board._cells[i][j] == TypeCell.INVADER) {
          board._cells[i][j] = TypeCell.EMPTY;
        }
      }
    }
    for (int i = 0; i < invaders.length; ++i) {
      board._cells[invaders[i]._cellY][invaders[i]._cellX] = TypeCell.INVADER;
      invaders[i].set_relative();                                                              // update.
    }
  }
  // check if invaders reached the right edge of the board
  boolean right_edge() {
    boolean x = false;
    for (int i = 0; i < invaders.length; ++i) {
      if ((invaders[i].right_line == true ) && (invaders[i]._cellX == board._cells[0].length  - 1)) {
        x = true;
        break;
      }
    }
    return x;
  }
  // check if invaders reached the left edge of the board
  boolean left_edge() {
    boolean x = false;
    for (int i = 0; i < invaders.length; ++i) {
      if ((invaders[i].left_line == true ) && (invaders[i]._cellX == 0)) {
        x = true;
        break;
      }
    }
    return x;
  }

  // check if the invaders reached the losing area and end the game if so
  void land_edge() {
    for (int i = 0; i < invaders.length; ++i) {
      if ((invaders[i].front_line == true ) && (invaders[i]._cellY == ship._cellY)) {                   // ennemi atteint la fin du tableau.
        Sound.game_over();
        save_score();
        highscore();        
        game_state="loose_game";
        in_game_music.stop();    
      }
    }
  }
  // randomely select an invader to shoot
  void shoot() {
    if (enemies.nbInvaders >= 1) {
      if (millis() - invaders_last_shot < invaders_fire_rate) {
        return;
      }
      int index = floor(random(0, invaders.length));
      for (int i = 0; i < enemies_bullets.length; ++i) {
        if (enemies_bullets[i]._isMoving == false) {
          enemies_bullets[i]._position.set(invaders[index]._position.x, invaders[index]._position.y+10);//the 10 is temporary
          enemies_bullets[i]._isMoving = true;
          enemies_bullets[i].update();
          invaders_last_shot = millis();
          break;
        }
      }
    }
    if (enemies.nbInvaders < 1) {                                                               // méthode niveau suivant.
      //game_state="fin_level";
    }
  }
  // remove an invader from the array
  void removeByIndex(int i) {
    int i2 = invaders.length-1;
    invaders[i] = invaders[i2];
    invaders = (Enemy[]) shorten(invaders);
  }
  void drawIt() {
    for (int i = 0; i < invaders.length; ++i) {
      fill(255, 0, 0);
      //ellipse(invaders[i]._position.x, invaders[i]._position.y, board._cellSize, board._cellSize);
      image(invader, invaders[i]._position.x-width*0.02, invaders[i]._position.y-height*0.04, board._cellSize, board._cellSize);                              //._cellSize, board._cellSize);
    }
  }
}

class Enemy {
  // position on screen
  PVector _position;
  // position on board
  int _cellX, _cellY;
  // booleans to know the relative position of each enemy in the invaders
  boolean right_line = false, front_line = false, left_line = false;
  Enemy(int x, int y) {
    _cellX = x;
    _cellY = y;
    _position = board.getCellCenter(y, x).copy();
    set_relative();
  }
  // set the relative position of an invader to others
  void set_relative() {
    int max_x = -1;
    int min_x = 1000;
    int max_y = -1;
    max_x = get_max_x(max_x);
    min_x = get_min_x(min_x);
    max_y = get_max_y(max_y);
    if (_cellX == max_x) {
      right_line = true;
    }
    if (_cellX == min_x) {
      left_line  = true;
    }
    if (_cellY == max_y) {
      front_line = true;
    }
  }
  // get the biggest x coordinate of the invaders
  int get_max_x(int max_x) {
    for (int i = 0; i < board._cells.length; ++i) {
      for (int j = 0; j < board._cells[i].length; ++j) {
        if (board._cells[i][j] != TypeCell.INVADER) {
          continue;
        }
        if (j > max_x ) {
          max_x = j;
        }
      }
    }
    return max_x;
  }
  // get the minimum x coordinate of the invaders
  int get_min_x(int min_x) {
    for (int i = 0; i < board._cells.length; ++i) {
      for (int j = 0; j < board._cells[i].length; ++j) {
        if (board._cells[i][j] != TypeCell.INVADER) {
          continue;
        }
        if (j < min_x ) {
          min_x = j;
        }
      }
    }
    return min_x;
  }
  // get the biggest y coordinate of the invaders
  int get_max_y(int max_y) {
    for (int i = 0; i < board._cells.length; ++i) {
      for (int j = 0; j < board._cells[i].length; ++j) {
        if (board._cells[i][j] != TypeCell.INVADER) {
          continue;
        }
        if (i > max_y) {
          max_y = i;
        }
      }
    }
    return max_y;
  }
  // 20% chance to drop a bonus if one is not already effective or dropped
  void drop_bonus() {
    if ((int(random(0, 5)) != 1) || (bonus.collected == true) || (bonus._isMoving == true)) {
      return;
    }
    int chance = int(random(0, 100));
    if (chance < 35) {
      bonus._bonus_type = TypeBonus.DOUBLE_SCORE;
    } else if ((chance > 34 ) && (chance < 55 )) {
      bonus._bonus_type = TypeBonus.HEALTH_POINT;
    } else if ((chance > 54 ) && ( chance < 70)) {
      bonus._bonus_type = TypeBonus.TRIPLE_FIRE_RATE;
    } else {
      bonus._bonus_type = TypeBonus.DOUBLE_FIRE_RATE;
    }
    bonus._isMoving = true;
    bonus._position = _position.copy();
    bonus.update();
  }
}
