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
public int bottomYCor;
public int lastFrameCount = 0;
public int allowance = 0;
public boolean drop = true;
// Setup Method
void setup() {
    size(540, 720);
    gridCreation();
    borderCreation();
    drawGrid();
    drawBorder();
    regenBlock();
}
void draw() {
  updateGrid();
  outlineDrop();
  drawGrid();
  if (frameCount % speed == 0) {
    updateBlock();
  }
  // System.out.println(curBlock.coordIncident());
}

void keyPressed() {
  if (key == "A".charAt(0)) {
    curBlock.rotateB(1);
    curBlock.update();
    if (incident()) curBlock.rotateB(-1);
    else lastFrameCount = frameCount;
    key = 'Z';
  }
  else if (key == "D".charAt(0)) {
    curBlock.rotateB(-1);
    curBlock.update();
    if (incident()) curBlock.rotateB(1);
    else lastFrameCount = frameCount;
    key = 'Z';
  }
  else if (keyCode == LEFT) {
    if (curBlock.leftmostXGrid > 0) {
      curBlock.leftmostXGrid--;
      curBlock.update();
      if (incident()) curBlock.leftmostXGrid++;
      else lastFrameCount = frameCount;
      keyCode = 200;
    }
  }
  else if (keyCode == RIGHT) {
    if (curBlock.leftmostXGrid < 10 - curBlock.curBlock[0].length) {
      curBlock.leftmostXGrid++;
      curBlock.update();
      if (incident()) curBlock.leftmostXGrid--;
      else lastFrameCount = frameCount;
      keyCode = 200;
    }
  }
  else if (keyCode == DOWN) {
    speed = 20;
  }
  curBlock.update();
  updateGrid();
  drawGrid();
  coincidence();
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
            stroke(temp.border);
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
      if (k.curColor == defaultColor) k.filled = false;
      if (k.filled == false) k.setColor(defaultColor);
      k.border = color(0, 0, 0);
      if (k.filled == true) k.setColor(color(0, 255, 0));
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
  coincidence();
  curBlock.leftmostYGrid++;
  curBlock.update();
  updateGrid();
  coincidence();
}

void regenBlock() {
  curBlock = new Blocks();
  bottomYCor = 0;
  lastFrameCount = 0;
}

void outlineDrop() {
  PVector leftmostOutline = curBlock.coordIncident();
  ArrayList<PVector> outlineCoords = new ArrayList<PVector>();
  for (int i = 0; i < curBlock.curBlock.length; i++) {
      for (int j = 0; j < curBlock.curBlock[i].length; j++) {
        if (curBlock.curBlock[i][j] == 1) {
          outlineCoords.add(new PVector((int) leftmostOutline.x + j, (int) leftmostOutline.y + i));
        }
      }
    }
    for (PVector i : outlineCoords) {
      coordinates[(int) i.y][(int) i.x].border = curBlock.shapeToColor();
    }
}

boolean matches(PVector k, PVector i) {
  return ((int) k.x == (int) i.x) && ((int) k.y == (int) i.y);
}

boolean incident() {
  for (PVector i : curBlock.coords) {
    if (i.y > 19 || i.y < 0 || i.x < 0 || i.x > 9 || coordinates[(int) i.y][(int) i.x].filled == true) {
      return true;
    }
  }
  return false;
}

void coincidence() {
  int yLen = curBlock.curBlock.length;
  bottomYCor = curBlock.leftmostYGrid + yLen;
  PVector incidence = curBlock.coordIncident();
  int bottomYIncidence = (int) incidence.y + yLen;
  if (bottomYCor > 19 || bottomYCor == bottomYIncidence) {
    for (PVector i : curBlock.coords) {
      System.out.println(i.y);
      int corX = (int) i.x - curBlock.leftmostXGrid;
      int corY = (int) i.y - curBlock.leftmostYGrid;
      System.out.println("" + corX + "    " + corY);
      if (curBlock.curBlock[corY][corX] == 1)
      coordinates[(int) i.y][(int) i.x].filled = true;
    }
    regenBlock();
    }
  }


/**
Game Procedure:
1. Board Drawn
2. Falling Procedure/Coordinate Support for blocks
3. Tracking full grid squares (use leftmost and furthest down part)
4. Random choosing
*/
