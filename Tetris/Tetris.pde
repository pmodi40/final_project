/**
Pranjal Modi - Tetris Final Project
*/
// Fields
public Grid[][] coordinates = new Grid[20][10];
public Grid[][] border = new Grid[28][18];
public Grid[][] nextCoords = new Grid[12][3];
public Blocks curBlock;
public Blocks[] nextBlocks = new Blocks[3];
public color defaultColor = color(0, 0, 0);
public color defaultBorderColor = color(175, 139, 125);
public int speed = 100;
public int bottomYCor;
public int dropStep = 1;
public ArrayList<Integer> linesToRemove = new ArrayList<Integer>();
public int lastFrameCount;
public int score;
public PFont fontToUse;
// Setup Method
void setup() {
    size(540, 840);
    fontToUse = loadFont("PTMono-Bold-60.vlw");
    gridCreation();
    borderCreation();
    drawGrid();
    drawBorder();
    for (int i = 0; i < 3; i++) {
      Blocks newB = new Blocks();
      newB.rotationState = 0;
      nextBlocks[i] = newB;
    }
    regenBlock();
    createNext();
    updateNext();
    drawNext();
}
void draw() {
  background(51);
  curBlock.update();
  drawBorder();
  adjustLines();
  updateGrid();
  outlineDrop();
  drawGrid();
  updateScoreTicker();
  createNext();
  updateNext();
  drawNext();
  if (frameCount % speed == 0) {
    updateBlock();
    speed = 100;
  }
  // System.out.println(curBlock.coordIncident());
}
void mouseClicked() {
  if (pmouseX > 30 && pmouseX < 90 && pmouseY > 30 && pmouseY < 90) {
    end();
    exit();
  }
  else if (pmouseX > 420 && pmouseX < 480 && pmouseY > 30 && pmouseY < 90) {
    delay(5000);
  }
  else {
    PVector leftDrop = curBlock.coordIncident();
    curBlock.leftmostXGrid = (int) leftDrop.x;
    curBlock.leftmostYGrid = (int) leftDrop.y;
    curBlock.update();
    updateGrid();
    drawGrid();
    coincidence();
  }
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
    int yOffset = 120;
    for (int i = 0; i < 20; i++) {
        for (int j = 0; j < 10; j++) {
            coordinates[i][j] = new Grid(30 * j + xOffset, 30 * i + yOffset, defaultColor);
        }
    }
}
void borderCreation() {
    for (int i = 0; i < 28; i++) {
        for (int j = 0; j < 18; j++) {
            if (i < 4 || i > 23 || j < 4 || j > 13) {
              if (i > 0 && i < 3 && j > 3 && j < 14) {
                Grid toBeAdded = new Grid(30 * j, 30 * i, color(112, 185, 247));
                toBeAdded.nameZone = true;
                border[i][j] = toBeAdded;
              }
              else if (i > 24 && i < 27 && j > 3 && j < 14) {
                Grid toBeAdded = new Grid(30 * j, 30 * i, color(112, 185, 247));
                toBeAdded.scoreZone = true;
                border[i][j] = toBeAdded;
              }
              else if (i > 0 && i < 3 && j > 0 && j < 3) {
                Grid toBeAdded = new Grid(30 * j, 30 * i, color(227, 36, 18));
                toBeAdded.endZone = true;
                border[i][j] = toBeAdded;
              }
              else if (i > 0 && i < 3 && j > 14 && j < 17) {
                Grid toBeAdded = new Grid(30 * j, 30 * i, color(85, 80, 80));
                toBeAdded.pauseZone = true;
                border[i][j] = toBeAdded;
              }
              else if (i > 10 && i < 17 && j > 14 && j < 17) {
                Grid toBeAdded = new Grid(30 * j, 30 * i, defaultBorderColor);
                toBeAdded.nextZone = true;
                border[i][j] = toBeAdded;
              }
              else {
                border[i][j] = new Grid(30 * j, 30 * i, defaultBorderColor);
              }
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
              noStroke();
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
  int nextBlock = nextBlocks[0].block;
  curBlock = new Blocks(nextBlock);
  nextBlocks[0] = nextBlocks[1];
  nextBlocks[1] = nextBlocks[2];
  nextBlocks[2] = new Blocks();
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
        score += 1; 
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
  score += Math.pow(5, linesToRemove.size());
    for (Integer i : linesToRemove) {
      for (Grid k : coordinates[i]) {
        k.filled = false;
        k.setColor(defaultColor);
      }
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
        newCoordinates[0][i] = new Grid(30 * i + 120, 120, defaultColor);
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
String repeat(String unit, int num) {
  String accum = "";
  for (int i = 0; i < num; i++) {
    accum += unit;
  }
  return accum;
}
void updateScoreTicker() {
  textAlign(CENTER);
  textFont(fontToUse);
  fill(color(255, 255, 255));
  textSize(60);
  int numZero = 6 - len(score);
  String displayMark = repeat("0", numZero) + score;
  text(displayMark, border[25][4].leftXCor, border[25][4].leftYCor + 7, 300, 60); 
  System.out.println(textAscent());
}
void drawNext() {
  for (int i = 0; i < nextCoords.length; i++) {
    for (int j = 0; j < nextCoords[0].length; j++) {
      Grid inQuestion = nextCoords[i][j];
      fill(inQuestion.curColor);
      rect(inQuestion.leftXCor, inQuestion.leftYCor, 20, 15);
    }
  }
}
void createNext() {
  int xOffset = 450;
  int yOffset = 300;
  for (int i = 0; i < 12; i++) {
      for (int j = 0; j < 3; j++) {
          nextCoords[i][j] = new Grid(20 * j + xOffset, 15 * i + yOffset, defaultColor);
      }
  }
}
void updateNext() {
  for (int i = 0; i < nextBlocks.length; i++) {
    Blocks toBeUsed = nextBlocks[i];
    int gridOffset = 0;
    if (toBeUsed.block < 6) {
      gridOffset = 1;
    }
    ArrayList<PVector> newCoords = new ArrayList<PVector>();
    for (int v = 0; v < toBeUsed.curBlock.length; v++) {
      for (int j = 0; j < toBeUsed.curBlock[0].length; j++) {
        if (toBeUsed.curBlock[v][j] == 1) {
          int off = j;
          if (toBeUsed.block > 4) off++;
          newCoords.add(new PVector(off, i * 4 + gridOffset + v));
        }
      }
    }
    System.out.println(newCoords);
    for (PVector k : newCoords) {
      int x = (int) k.x;
      int y = (int) k.y;
      nextCoords[y][x].curColor = toBeUsed.shapeToColor();
    }
  }
}
int len(int num) {
  String numS = "" + num;
  return numS.length();
}
void end() {
  for (Grid[] k : coordinates) {
    for (Grid j : k) {
      j.curColor = defaultColor;
    }
  }
  updateGrid();
  drawGrid();
}
/**
Game Procedure:
1. Board Drawn
2. Falling Procedure/Coordinate Support for blocks
3. Tracking full grid squares (use leftmost and furthest down part)
4. Random choosing
*/
