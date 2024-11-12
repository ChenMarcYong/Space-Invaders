class Spaceship {
  // Position on screen.
  PVector _position;
  // Position on board.
  int _cellX, _cellY;
  // Display size.
  float _size;

  // Move data.
  PVector _direction;
  boolean _isMoving; // Is moving?

  //heal points of the ship
  int _health_point;
  // Fire rate of the bullets
  int fire_rate = 500;
  int last_shot = -fire_rate;
  //used to allow the spaceship to move
  PVector new_pos;
  // Speed of the spaceship
  float speed = 0.1;
  PImage spaceship=loadImage("sprite/v2.png");

  Spaceship(PVector pos, int x, int y, float size, PVector dir, boolean move_data, int hp) {
    _position  = pos.copy();
    new_pos = _position.copy();
    _cellX     = x;
    _cellY     = y;
    _size      = size;
    _health_point = hp;
    _direction = dir.copy();
    _isMoving  = move_data;
  }
  //give the spaceship a new location
  void move(String direction) {
    if ((_position.x-10 >= new_pos.x)||(_position.x+10<= new_pos.x)) {
      return;
    } // the spaceship needs to reach a point to move one more time
    if ((direction == "RIGHT") && (_cellX < board._cells[_cellY].length - 1)) {
      new_pos = board.getCellCenter(_cellY, _cellX + 1 );
      _cellX += 1;
      update();
    } else if ((direction == "LEFT") && (_cellX > 0 )) {
      new_pos = board.getCellCenter(_cellY, _cellX - 1 );
      _cellX -= 1;
      update();
    }
  }
  // interpolatte the spaceship between the current location and its new one
  void interpolate() {
    //we use floor and ceil to get the exact value from lerp
    if (_position.x < new_pos.x) {
      _position.x = ceil(lerp(_position.x, new_pos.x, speed));
    } else {
      _position.x = floor(lerp(_position.x, new_pos.x, speed));
    }
  }
  //update the space ship position on the board
  void update() {
    for (int i = 0; i < board._cells[_cellY].length; ++i) {
      board._cells[_cellY][i] = TypeCell.EMPTY ;
    }
    board._cells[_cellY][_cellX] = TypeCell.SPACESHIP;
  }
  //draw the spaceship
  void drawIt() {
    fill(0);
    //ellipse(_position.x, _position.y, _size, _size);
    image(spaceship, _position.x-width*0.035, _position.y-height*0.01);                                                             // -width*0.035 pour centrer le vaisseau.
  }
  //get the cell of the location of the spaceship
  int getCellX(Board board) {
    return int(((_position.x - board._position.x) / board._cellSize)) ;
  }
  // allow the spaceship to shoot
  void shoot() {
    if (millis() - last_shot < (fire_rate / game._fireRate_reduction)) {
      return;
    }
    for (int i = 0; i < ss_bullets.length; ++i) {
      if (ss_bullets[i]._isMoving == false) {
        ss_bullets[i]._position.set(_position.x, _position.y-10); // the 10 is temporary it might change
        ss_bullets[i]._isMoving = true;
        ss_bullets[i].update();
        last_shot = millis();
        break;
      }
    }
  }
}

//initiate an object of type Spaceship
Spaceship initSpaceship() {
  int x = 0, y = 0;
  for (int i = 0; i < board._cells.length; ++i) {
    for (int j = 0; j < board._cells[i].length; ++j) {
      if (board._cells[i][j] == TypeCell.SPACESHIP ) {
        x = i;
        y = j;
      }
    }
  }
  return new Spaceship(board.getCellCenter(x, y ), y, x, board._cellSize, new PVector(0, 0 ), false, START_LIVES);
}
