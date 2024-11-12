// An enum is a special "class" that represents a group of constants.
enum TypeCell
{
  EMPTY,
    SPACESHIP,
    INVADER,
    OBSTACLE,
}

class Board
{
  TypeCell[][] _cells;
  PVector   _position;
  int       _nbCellsX;
  int       _nbCellsY;
  int       _cellSize; // Cells should be square.
  boolean _right = false, _left = false, _down = false;
  PImage astéroide=loadImage("sprite/a1.png");

  Board(PVector pos, int nbX, int nbY, int size, TypeCell[][] cells) {
    _position = pos.copy();
    _nbCellsX = nbX;
    _nbCellsY = nbY;
    _cellSize = size;
    _cells    = cells;
  }
  // get the center of a cell
  PVector getCellCenter(int i, int j) {
    return new PVector( _position.x + j * _cellSize + (_cellSize * 0.5),
      _position.y + i * _cellSize + (_cellSize * 0.5) );                                                  // position board.
  }
  // draw obtacles and the area of the board
  void drawIt() {
    PVector cell_pos;
    noFill();
    rectMode(CORNER);
    rect(_position.x, _position.y, _nbCellsX*_cellSize, _nbCellsY*_cellSize);
    for (int i = 0; i < _cells.length; ++i) {
      for (int j = 0; j < _cells[i].length; ++j) {
        cell_pos = getCellCenter(i, j).copy();
        switch (_cells[i][j]) {
        case OBSTACLE :
          //fill(0, 0, 200);
          // ellipse(cell_pos.x, cell_pos.y, _cellSize*0.95, _cellSize*0.95);                                                 // Obstacle.
          image(astéroide, cell_pos.x-width*0.0175, cell_pos.y-height*0.04, _cellSize*0.95, _cellSize*0.95);
          break;
        }
      }
    }
  }
}
//init an object of "Board"
Board initBoard(String level) {
  TypeCell[][] cells_board;
  cells_board = getCells(level);
  int nbX     = cells_board[0].length;
  int nbY     = cells_board.length;
  int size    = int(max((height / nbY)*0.9, (width / nbX)*0.9 ));
  PVector pos = new PVector( (width - size*nbX) / 2, (height - size*nbY) / 2 );
  return new Board(pos, nbX, nbY, size, cells_board);
}
//save the current Board to a text file
void saveBoard( String level) {
  String[] saved_file = new String[board._cells.length + 1];
  saved_file[0] = "Niveau "+level;
  for (int i = 1; i < saved_file.length; ++i) {
    switch (board._cells[i-1][0]) {
    case INVADER :
      saved_file[i] = "I";
      break;
    case EMPTY :
      saved_file[i] = "E";
      break;
    case OBSTACLE :
      saved_file[i] = "X";
      break;
    case SPACESHIP :
      saved_file[i] = "S";
      break;
    }
  }
  for (int i = 0; i < board._cells.length; ++i) {
    for (int j = 0; j < board._cells[i].length; ++j) {
      switch (board._cells[i][j]) {
      case INVADER :
        saved_file[i+1] += "I";
        break;
      case EMPTY :
        saved_file[i+1] += "E";
        break;
      case OBSTACLE :
        saved_file[i+1] += "X";
        break;
      case SPACESHIP :
        saved_file[i+1] += "S";
        break;
      }
    }
  }
  saveStrings("levels/saved_game/level"+level+".txt", saved_file);
}

// convert the text file level to TypeCell
TypeCell[][] getCells(String level) {
  String[] lines = loadStrings("levels/"+level+".txt");                                                          //niveau.
  TypeCell[][] board = new TypeCell[lines.length-1][lines[1].length()];
  for (int i = 1; i < lines.length; i++) {
    for (int j = 0; j < lines[i].length(); j++) {
      switch (lines[i].charAt(j)) {
      case 'E' :
        board[i-1][j] = TypeCell.EMPTY;
        break;	
      case 'S' :
        board[i-1][j] = TypeCell.SPACESHIP;
        break;	
      case 'X' :
        board[i-1][j] = TypeCell.OBSTACLE;
        break;	
      case 'I' :
        board[i-1][j] = TypeCell.INVADER;
        break;
      }
    }
  }
  return board;
}
void printBD() {
  for (int i = 0; i < board._cells.length; ++i) {
    for (int j = 0; j < board._cells[i].length; ++j) {
      switch (board._cells[i][j]) {
      case INVADER :
        print("I");
        break;	
      case EMPTY :
        print("E");
        break;	
      case OBSTACLE :
        print("X");
        break;	
      case SPACESHIP :
        print("S");
        break;
      }
    }
    println();
  }
}
