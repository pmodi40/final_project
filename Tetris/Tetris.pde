/**
Pranjal Modi - Tetris Final Project
*/
// Fields
public Grid[][] coordinates = new Grid[20][10];
public Grid[][] border = new Grid[24][18];
public Blocks curBlock;
public color defaultColor = color(0, 0, 0);
public color defaultBorderColor = color(255, 0, 0);
public int speed = 40;
// Setup Method
void setup() {
    size(540, 720);
    gridCreation();
    borderCreation();
    drawGrid();
    drawBorder();
    Blocks k = new Blocks(3, 2, 4, 7);
    curBlock = k;
}
void draw() {
  updateGrid();
  drawGrid();
  if (frameCount % speed == 0) {
    updateBlock();
  }
}
void keyPressed() {
  if (key == "A".charAt(0)) curBlock.rotateB(1);
  else if (key == "D".charAt(0)) curBlock.rotateB(-1);
  else if (keyCode == LEFT) {
    if (curBlock.leftmostXGrid > 0) {
      curBlock.leftmostXGrid--;
    }
  }
  else if (keyCode == RIGHT) {
    if (curBlock.leftmostXGrid < 10 - curBlock.curBlock[0].length) {
      curBlock.leftmostXGrid++;
    }
  }
}
// Grid Initialization
void gridCreation() {
    int xOffset = 120;
    int yOffset = 60;
    for (int i = 0; i < 20; i++) {
        for (int j = 0; j < 10; j++) {
            coordinates[i][j] = new Grid(30 * j + xOffset, 30 * i + yOffset, defaultColor);
        }
    }
}
void borderCreation() {
    for (int i = 0; i < 24; i++) {
        for (int j = 0; j < 18; j++) {
            if (i < 2 || i > 21 || j < 4 || j > 13) {
                border[i][j] = new Grid(30 * j, 30 * i, defaultBorderColor);
            }
        }
    }
}
// Drawing
void drawGrid() {
    for (int i = 0; i < coordinates.length; i++) {
        for (int j = 0; j < coordinates[i].length; j++) {
            Grid temp = coordinates[i][j];
            fill(temp.curColor);
            square(temp.leftXCor, temp.leftYCor, 30);
        }
    }
}
void drawBorder() {
    for (int i = 0; i < border.length; i++) {
        for (int j = 0; j < border[i].length; j++) {
            Grid temp = border[i][j];
            if (temp != null) {
                fill(temp.curColor);
                square(temp.leftXCor, temp.leftYCor, 30);
            }
        }
    }
}

void updateGrid() {
  curBlock.update();
  for (Grid[] i : coordinates) {
    for (Grid k : i) {
      if (k.filled == false) k.setColor(defaultColor);
    }
  }
  for (PVector i : curBlock.coords) {
    int xCor = (int) i.x;
    int yCor = (int) i.y;
    coordinates[yCor][xCor].setColor(curBlock.shapeToColor());
  }
}

void updateBlock() {
  drop();
}

void drop() {
  curBlock.leftmostYGrid++;
  updateGrid();
  int yLen = curBlock.curBlock.length;
  int bottomYCor = curBlock.leftmostYGrid + yLen;
  if (bottomYCor > 19) {
    for (PVector i : curBlock.coords) {
      System.out.println(i.y);
      coordinates[(int) i.y][(int) i.x].filled = true;
    }
    regenBlock();
  }
}

void regenBlock() {
  curBlock = new Blocks();
}
/**
Game Procedure:
1. Board Drawn
2. Falling Procedure/Coordinate Support for blocks
3. Tracking full grid squares (use leftmost and furthest down part)
4. Random choosing
*/
