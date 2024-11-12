enum TypeBonus {
  DOUBLE_FIRE_RATE,
    TRIPLE_FIRE_RATE,
    DOUBLE_SCORE,
    HEALTH_POINT,
    NONE,
}



class Bonus {
  //bonus drop speed
  int bonus_speed = 5;
  //type of the bonus
  TypeBonus _bonus_type = TypeBonus.NONE;
  // position on screen
  PVector _position = new PVector(-60, -60);
  //moving data
  boolean _isMoving = false;
  // position on board
  int _cellY, _cellX;
  //last bonus collected
  int last_bonus_collected = 5000;
  // bonus delay to drop
  int bonus_delay = 7000;
  // bonus duration
  int bonus_duration = 5000;
  // if the bonus is collected
  boolean collected = false;
  Bonus() {
  }
  // allow the bonus to drop down in a straight line
  void move() {
    if (_isMoving == false) {
      return;
    }
    _position.y += bonus_speed;
    if (board._cells[_cellY][_cellX] == TypeCell.SPACESHIP || board._cells[_cellY][_cellX-1] == TypeCell.SPACESHIP || board._cells[_cellY][_cellX+1] == TypeCell.SPACESHIP) {
      Sound.bonus();
      collected = true;
      _position.set(-50, -50);
      _isMoving = false;
      last_bonus_collected = millis();
    } else if ((_position.y < (board._position.y + (board._nbCellsY*board._cellSize)))&&
      (_position.y > (board._position.y + (board._nbCellsY*board._cellSize) ) - 12)) {
      _position.set(-50, -50);
      _isMoving = false;
      _bonus_type = TypeBonus.NONE;
    }
    update();
  }
  void apply() {
    if (collected == false) {
      return;
    }
    if (bonus._bonus_type == TypeBonus.DOUBLE_FIRE_RATE) {
      game._fireRate_reduction = 2;
    } else if (bonus._bonus_type == TypeBonus.TRIPLE_FIRE_RATE) {
      game._fireRate_reduction = 3;
    } else if (bonus._bonus_type == TypeBonus.HEALTH_POINT) {
      bonus_duration=1;
      if (game._lives < 3) {
        game._lives ++;
      } else if (game._lives >= 3) {
        game._score+=150;
      }
      bonus_duration=5000;
      collected = false;
    } else if (bonus._bonus_type == TypeBonus.DOUBLE_SCORE) {
      game._multiplier = 2;
    }
    if (millis() - last_bonus_collected > bonus_duration) {
      collected = false;
      game._multiplier = 1;
      game._fireRate_reduction = 1;
    }
  }


  // update the position of the bonus on board
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
  void drawIt() {

    if (_bonus_type == TypeBonus.HEALTH_POINT) {
      fill(255, 0, 0);
      rectMode(CENTER);
      //rect(_position.x,_position.y,40,40);
      image(levels.coeur, _position.x-width*0.05, _position.y-height*0.02);
    }
    if (_bonus_type == TypeBonus.DOUBLE_FIRE_RATE) {
      fill(0);
      rectMode(CENTER);
      //rect(_position.x,_position.y,40,40);
      image(levels.double_fire_rate, _position.x-width*0.025, _position.y-height*0.01, 40, 40);
    }
    if (_bonus_type == TypeBonus.TRIPLE_FIRE_RATE) {
      fill(0, 0, 255);
      rectMode(CENTER);
      //rect(_position.x,_position.y,40,40);
      image(levels.triple_fire_rate, _position.x-width*0.025, _position.y-height*0.01, 40, 40);
    }
    if (_bonus_type == TypeBonus.DOUBLE_SCORE) {
      fill(0, 0, 255);
      //ellipse(_position.x,_position.y , 40,40);
      image(levels.double_points, _position.x-width*0.025, _position.y-height*0.01);
    }
  }
}
