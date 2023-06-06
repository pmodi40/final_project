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
public color from;
public int speed = 100;
public int bottomYCor;
public ArrayList<Integer> linesToRemove = new ArrayList<Integer>();
public int lastFrameCount;
public int score;
public int highScore = 0;
public PFont fontToUse;
public Level curLevel = new Level("Level 1", 1, 100, 400);
public boolean paused = false;
public String gameMode = "Starting";
public int levelChange = 0;
public StartingScreen curScreen;
private int lastI;
private int lastG;
public int circlesRemaining;
// Constants
public final double logisticConstant = -1. * (Math.log(999599.0 / 400.0) / 20.0);
public final color[] gradientStart = {color(52, 141, 224), color(230, 107, 46), color(38, 181, 88), color(168, 19, 116), color(135, 41, 194), color(179, 27, 27), color(152, 209, 19), color(9, 233, 237)};
// Setup Method
void setup() {
    size(540, 840);
    fontToUse = loadFont("PTMono-Bold-60.vlw");
    startingSetup();
}
void progressionSetup() {
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
  score = 0;
  curLevel = new Level("Level 1", 1, 100, 400);
  linesToRemove = new ArrayList<Integer>();
  lastI = 0;
  lastG = 0;
}
void startingSetup() {
  curScreen = new StartingScreen(1);
  drawStartingScreen();
}
void arcadeSetup() {
  speed = 100;
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
  score = 0;
  curLevel = null;
  linesToRemove = new ArrayList<Integer>();
  lastI = 0;
  lastG = 0;
  String toBeDisplayed = "Arcade!";
  textInit((int) (480 / toBeDisplayed.length()), color(255, 255, 255));
  int above = (int) textAscent();
  text(toBeDisplayed, 120, 30 + above, 300, 60);
}
void draw() {
  if (gameMode.equals("Progression")) {
    if (levelChange == 2) {
      levelChangeEnd();
      levelChange = 0;
      resetBoard();
    }
    if (levelChange == 1) {
      levelChangeProcess();
    }
    else {
      try {
        progressionModeMain();
      }
      catch (Exception e) {
        gameOver();
      }
    }
  }
  else if (gameMode.equals("Arcade")) {
    try {
      arcadeMain();
    }
    catch (Exception e) {
      gameOver();
    }
  }
  else if (gameMode.equals("Starting")) {
    drawStartingScreen();
  }
  else if (gameMode.equals("Transitioning")) {
    if (lastI < 28) {
      transitionOutGame();
    }
    else {
      frameRate(60);
      textFrame();
    }
  }
  else if (gameMode.equals("TransitionTwo")) {
    if (lastI < 28) {
      transitionTwoOverall();
    }
    else {
      frameRate(60);
      arcadeSetup();
      gameMode = "Arcade";
    }
  }
}
void textFrame() {
  if (lastFrameCount == 0) lastFrameCount = frameCount;
      if (Math.abs(lastFrameCount - frameCount) < 800) {
        background(51);
        drawFullBorder();
        textSize(100);
        textAlign(CENTER);
        fill(color(255, 255, 255));
        text("Game Over!", 0, 300, 540, 210);
      }
      else {
        lastFrameCount = 0;
        gameMode = "Starting";
        curScreen = new StartingScreen(0);
      }
}
void drawStartingScreen() {
  if (curScreen.type == 0) {
    drawExt();
    for (Grid[] i : curScreen.overallCoordinates) {
      for (Grid k : i) {
        if (k.curColor != color(52, 141, 224)) {
          if (k.border == color(19, 19, 19)) {
            noStroke();
          }
          else {
            stroke(k.border);
          }
          fill(k.curColor);
          square(k.leftXCor, k.leftYCor, 30);
        }
      }
    }
    String playScreen = "Play!";
    int size = textSizeGen(playScreen, 480);
    textInit(size, color(255, 255, 255));
    int above = (int) textAscent();
    text(playScreen, 150, 570 + above - 15, 240, 180);
    int numZero = 6 - len(highScore);
    String highScoreScreen = repeat("0", numZero) + highScore;
    size = textSizeGen(highScoreScreen, 240);
    textInit(size, color(255, 255, 255));
    text(highScoreScreen, 180, 360 + (int) textAscent() * 2, 180, 150);
    PImage tetrisLogo = loadImage("tetris-logo.png");
    tetrisLogo.resize(360, 240);
    image(tetrisLogo, 90, 60);
  }
  else if (curScreen.type == 1) {
    /*
    for (Grid[] i : curScreen.overallCoordinates) {
      for (Grid k : i) {
        if (k.curColor != color(52, 141, 224)) {
          if (k.border == color(19, 19, 19)) {
            noStroke();
          }
          else {
            stroke(k.border);
          }
          fill(k.curColor);
          square(k.leftXCor, k.leftYCor, 30);
        }
      }
    }
    */
    gradientHalves();
  }
}
void drawExt() {
  if (lastFrameCount == 0) {
    background(12);
    fill(color(0, 0, 0));
    circle(0, 0, 9000);
    lastFrameCount = frameCount;
    from = gradientStart[(int) (Math.random() * 8)];
  }
  else if (Math.abs(lastFrameCount - frameCount) % 1 == 0) {
    color to = color(0, 0, 0);
    int i = 84 - (frameCount - lastFrameCount) / 1;
    if (i < 1) {
      frameRate(120);
      i = Math.abs(i);
      fill(defaultColor);
      int radius = 840 - (70 - i) * 10;
      circle(270, 420, radius);
      // delay(1);
      if (i == 84) {
        frameRate(60);
        lastFrameCount = 0;
        lastI = 0;
        lastG = 0;
      }
    }
    else {
      noStroke();
      float progressFactor = (i * (1. / 84.));
      int radius = 840 - (70 - i) * 10;
      color inter = lerpColor(from, to, progressFactor);
      fill(inter);
      circle(270, 420, radius);
    }
  }
}
void initBorder() {
  for (int i = 0; i < border.length; i++) {
    for (int j = 0; j < border[i].length; j++) {
      if (i > 3 && i < 24 && j > 3 && j < 14) {
        if (!gameMode.equals("TransitionTwo")) {
          border[i][j] = coordinates[i - 4][j - 4];
          border[i][j].border = color(2, 2, 2);
        }
        else {
          border[i][j] = curScreen.overallCoordinates[i][j];
        }
      }
    }
  }
}
void transitionTwoOverall() {
  frameRate(250);
  fill(color(255, 255, 255));
  noStroke();
  square(lastG * 30, lastI * 30, 30);
  lastG++;
  if (lastG >= 18) {
    lastG = 0;
    lastI++;
  }
}
void drawFullBorder() {
  for (Grid[] k : border) {
    for (Grid v : k) {
      if (v.border == color(17,29,37)) noStroke();
      else if (v.border == color(2, 2, 2)) stroke(v.border);
      else noStroke();
      fill(v.curColor);
      square(v.leftXCor, v.leftYCor, 30);
    }
  }
}
void transitionOutGame() {
  frameRate(250);
  Grid toBeAdded = new Grid(lastG * 30, lastI * 30, color(255, 0, 0));
  toBeAdded.border = color(17,29,37);
  border[lastI][lastG] = toBeAdded;
  lastG++;
  if (lastG >= 18) {
    lastG = 0;
    lastI++;
  }
  drawFullBorder();
}
void levelChangeEnd() {
  delay(5000);
  updateLevel();
}
void levelChangeProcess() {
  levelChange++;
  background(51);
  drawBorder();
  curBlock = null;
  drawGrid();
  if (score > highScore) highScore = score;
  System.out.println(score);
  updateScoreTicker();
  int levelNum = curLevel.num;
  String toBeDisplayed = "Level " + levelNum + ": " + curLevel.lvlScore;
  textInit((int) (480 / toBeDisplayed.length()), color(0, 255, 0));
  int above = (int) textAscent();
  text(toBeDisplayed, border[1][4].leftXCor, border[1][4].leftYCor + above, 300, 60);
  createNext();
  updateNext();
  drawNext();
}
void progressionModeMain() throws Exception {
  background(51);
  curBlock.update();
  drawBorder();
  adjustLines();
  updateGrid();
  outlineDrop();
  lvlUp();
  drawGrid();
  updateScoreTicker();
  updateLevelTicker();
  createNext();
  updateNext();
  drawNext();
  if (frameCount % curLevel.lvlSpeed == 0) {
    updateBlock();
    curLevel.lvlSpeed = speed;
  }
}
void progressionMouse() throws Exception {
  if (mouseX > 30 && mouseX < 90 && mouseY > 30 && mouseY < 90) {
    gameOver();
  }
  else if (mouseX > 420 && mouseX < 480 && mouseY > 30 && mouseY < 90) {
    paused = !paused;
    if (paused) noLoop();
    else loop();
  }
  else {
    if (!paused) {
        PVector leftDrop = curBlock.coordIncident();
        curBlock.leftmostXGrid = (int) leftDrop.x;
        curBlock.leftmostYGrid = (int) leftDrop.y;
        curBlock.update();
        updateGrid();
        drawGrid();
        coincidence();  
    }
  }
}
void mouseClicked() {
  if (gameMode.equals("Progression")) {
    try {
      progressionMouse();
    }
    catch (Exception e) {
      gameOver();
    }
  }
  else if (gameMode.equals("Starting")) {
    startingMouse();
  }
  else if (gameMode.equals("Arcade")) {
    try {
      arcadeMouse();
    }
    catch (Exception e) {
      gameOver();
    }
  }
}
void arcadeMouse() throws Exception {
  progressionMouse();
}
void arcadeMain() throws Exception {
  background(51);
  curBlock.update();
  drawBorder();
  adjustLines();
  updateGrid();
  outlineDrop();
  drawGrid();
  updateScoreTicker();
  String toBeDisplayed = "Arcade!";
  textInit(45, color(255, 255, 255));
  text(toBeDisplayed, 120, 30 + 15, 300, 60);
  createNext();
  updateNext();
  drawNext();
  if (frameCount % speed == 0) {
    updateBlock();
    speed = 100;
  }
}
void arcadeKey() throws Exception {
  basicKey();
  if (keyCode == DOWN) {
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
void startingMouse() {
  int x = mouseX;
  int y = mouseY;
  if (x > 120 && x < 390 && y > 540 && y < 750) {
    // curScreen = new StartingScreen(1);
    gameMode = "TransitionTwo";
    lastI = 0;
    lastG = 0;
  }
}
void basicKey() {
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
}
void progressionKey() throws Exception {
  basicKey();
  if (keyCode == DOWN) {
    curLevel.lvlSpeed = 5;
  }
  else if (keyCode == UP) {
    curLevel.lvlSpeed = 5;
  }
    curBlock.update();
    updateGrid();
    drawGrid();
    coincidence();
}
void keyPressed() {
  if (gameMode.equals("Progression")) {
    try {
      progressionKey();
    }
    catch (Exception e) {
      gameOver();
    }
  }
  else if (gameMode.equals("Arcade")) {
    try {
      arcadeKey();
    }
    catch (Exception e) {
      gameOver();
    }
  }
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

void updateBlock() throws Exception {
  drop();
}

void drop() throws Exception {
  coincidence();
  curBlock.leftmostYGrid++;
  curBlock.update();
  updateGrid();
  drawGrid();
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

void outlineDrop() throws Exception {
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

void coincidence() throws Exception {
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

void adjustLines() throws Exception {
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
  if (Math.abs(lastFrameCount - frameCount) > 49) {
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
  textInit(60, color(255, 255, 255));
  int numZero = 6 - len(score);
  String displayMark = repeat("0", numZero) + score;
  text(displayMark, border[25][4].leftXCor, border[25][4].leftYCor + 7, 300, 60); 
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
void updateLevelTicker() {
  int levelNum = curLevel.num;
  String toBeDisplayed = "Level " + levelNum + ": " + curLevel.lvlScore;
  textInit((int) (480 / toBeDisplayed.length()), color(255, 255, 255));
  int above = (int) textAscent();
  text(toBeDisplayed, border[1][4].leftXCor, border[1][4].leftYCor + above, 300, 60);
}
void textInit(int size, color set) {
  textAlign(CENTER);
  textFont(fontToUse);
  fill(set);
  textSize(size);
}
int textSizeGen(String text, int widthText) {
  return (int) (widthText / text.length());
}
void updateLevel() {
  resetBoard();
  int newNum = curLevel.num + 1;
  int newSpeed = expSpeed(newNum);
  int newScore = expScore(newNum);
  speed = newSpeed;
  Level newLevel = new Level("Level " + newNum, newNum, newSpeed, newScore);
  curLevel = newLevel;
}
void lvlUp() {
  if (score > curLevel.lvlScore) {
    levelChange = 1;
  }
}
void resetBoard() {
  for (Grid[] i : coordinates) {
    for (Grid k : i) {
      k.curColor = defaultColor;
      k.filled = false;
    }
  }
  score = 0;
  curBlock = null;
  bottomYCor = 0;
  paused = false;
  regenBlock();
  linesToRemove = new ArrayList<Integer>();
}
int expSpeed(int seed) { // Exponential
  return (int) (96 * Math.pow(1.25, -1. * (seed - 1)) + 4);
}
int expScore(int seed) { // Logistic
  return (int) (999999. / (1. + Math.exp(logisticConstant * (seed - 21))));
}
void gameOver() {
  if (score > highScore) highScore = score;
  gameMode = "Transitioning";
  initBorder();
}
void gradientHalves() {
  // Bounds: i = 2 -> 12; i = 15 -> 25; j = 2 -> 15
  if (lastFrameCount == 0) {
    background(color(0, 0, 0));
    lastFrameCount = frameCount;
    from = gradientStart[(int) (Math.random() * 8)];
  }
  else if (Math.abs(lastFrameCount - frameCount) % 1 == 0) {
    int i = (frameCount - lastFrameCount) / 1;
    int xPos1 = 480 - 5 * (i);
    int xPos2 = 5 * (i - 1) + 60;
    if (i > 84) {
      i = i - 84;
      xPos1 = 480 - 5 * (i);
      xPos2 = 5 * (i - 1) + 60;
      fill(defaultColor);
      rect(xPos1, 60, 5, 330);
      rect(xPos2, 450, 5, 330);
      if (i + 84 > 167 ) {
      lastFrameCount = 0;
      lastI = 0;
      lastG = 0;
    }
    }
    else {
      noStroke();
      color to = color(0, 0, 0);
      float progressFactor = (float) (i * (1. / 84.));
      color inter = lerpColor(from, to, progressFactor);
      fill(inter);
      rect(xPos1, 60, 5, 330);
      rect(xPos2, 450, 5, 330);
  }
}
}
