/**
Pranjal Modi - Tetris Final Project
*/
// Fields
public Grid[][] coordinates = new Grid[20][10];
public Grid[][] border = new Grid[24][18];
public Blocks curBlock;
public color defaultColor = color(0, 0, 0);
public color defaultBorderColor = color(175, 139, 125);
public int speed = 100;
public int bottomYCor;
public int dropStep = 1;
public ArrayList<Integer> linesToRemove = new ArrayList<Integer>();
public int lastFrameCount;
public int score;
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
  background(51);
  curBlock.update();
  drawBorder();
  adjustLines();
  updateGrid();
  outlineDrop();
  drawGrid();
  if (frameCount % speed == 0) {
    updateBlock();
    speed = 100;
  }
  // System.out.println(curBlock.coordIncident());
}
void mouseClicked() {
  PVector leftDrop = curBlock.coordIncident();
  curBlock.leftmostXGrid = (int) leftDrop.x;
  curBlock.leftmostYGrid = (int) leftDrop.y;
  curBlock.update();
  updateGrid();
  drawGrid();
  coincidence();
}
void keyPressed() {
  if (key == "A".charAt(0)) {
    curBlock.rotateB(1);
    curBlock.update();
    if (incident()) curBlock.rotateB(-1);
  }
  else if (key == "D".charAt(0)) {
    curBlock.rotateB(-1);
    curBlock.update();
    if (incident()) curBlock.rotateB(1);
  }
  else if (keyCode == LEFT) {
    if (curBlock.leftmostXGrid > 0) {
      curBlock.leftmostXGrid--;
      curBlock.update();
      if (incident()) curBlock.leftmostXGrid++;
    }
  }
  else if (keyCode == RIGHT) {
    if (curBlock.leftmostXGrid < 10 - curBlock.curBlock[0].length) {
      curBlock.leftmostXGrid++;
      curBlock.update();
      if (incident()) curBlock.leftmostXGrid--;
    }
  }
  else if (keyCode == DOWN) {
    speed = 5;
  }
  else if (keyCode == UP) {
    speed = 5;
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
            stroke(defaultColor);
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
  System.out.println(score);
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
}

void outlineDrop() {
  PVector leftmostOutline = curBlock.coordIncident();
  ArrayList<PVector> outlineCoords = curBlock.outlineCoordinates(leftmostOutline);
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
      // System.out.println(i.y);
      int corX = (int) i.x - curBlock.leftmostXGrid;
      int corY = (int) i.y - curBlock.leftmostYGrid;
      // System.out.println("" + corX + "    " + corY);
      if (curBlock.curBlock[corY][corX] == 1) {
        coordinates[(int) i.y][(int) i.x].filled = true;
        score += 2; 
      }
    }
    regenBlock();
    adjustLines();
    
    }
  }

void adjustLines() {
  curBlock.update();
  updateGrid();
  drawGrid();
  if (linesToRemove.size() == 0) {
  for (int i = 19; i >= 0; i--) {
    boolean filled = true;
    for (Grid k : coordinates[i]) {
      filled &= k.filled;
    }
    if (filled) {
      linesToRemove.add(i);
    }
  }
  for (Integer i : linesToRemove) {
    for (Grid k : coordinates[i]) {
      k.setColor(color(255, 255, 255));
      updateGrid();
      outlineDrop();
      drawGrid();
    }
  }
  lastFrameCount = frameCount;
  }
  if (Math.abs(lastFrameCount - frameCount) > 49) { // Adapt to middle clears!
    for (Integer i : linesToRemove) {
      for (Grid k : coordinates[i]) {
        k.filled = false;
        k.setColor(defaultColor);
      }
      score += 100;
    }
    Grid[][] newCoordinates = deepCopy(coordinates);
    for (int k = linesToRemove.size() - 1; k >= 0; k--) {
      for (int i = 0; i < linesToRemove.get(k); i++) {
        for (int j = 0; j < coordinates[i].length; j++) {
          Grid oldGrid = coordinates[i][j];
          Grid newGrid = new Grid(oldGrid.leftXCor, oldGrid.leftYCor + 30, oldGrid.curColor);
          newGrid.filled = oldGrid.filled;
          newGrid.border = oldGrid.border;
          newCoordinates[i + 1][j] = newGrid;
        }
      }
      for (int i = 0; i < newCoordinates[0].length; i++) {
        newCoordinates[0][i] = new Grid(30 * i + 120, 60, defaultColor);
      }
      coordinates = deepCopy(newCoordinates);
    }
    coordinates = newCoordinates;
    curBlock.update();
    linesToRemove = new ArrayList<Integer>();
    lastFrameCount = 0;
  }
}
Grid[][] deepCopy(Grid[][] toBeCopied) {
  Grid[][] copy = new Grid[toBeCopied.length][toBeCopied[0].length];
  for (int i = 0; i < toBeCopied.length; i++) {
    for (int j = 0; j < toBeCopied[i].length; j++) {
      copy[i][j] = toBeCopied[i][j];
    }
  }
  return copy;
}
/**
Game Procedure:
1. Board Drawn
2. Falling Procedure/Coordinate Support for blocks
3. Tracking full grid squares (use leftmost and furthest down part)
4. Random choosing
*/
