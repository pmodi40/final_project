class StartingScreen {
  Grid[][] overallCoordinates = new Grid[28][18];
  int type;
  // Constructor
  public StartingScreen(int type) {
    this.type = type;
    if (type == 0) {
      for (int i = 0; i < overallCoordinates.length; i++) {
        for (int j = 0; j < overallCoordinates[i].length; j++) {
          int xPos = 30 * j;
          int yPos = 30 * i;
          if (i > 18 && i < 25 && j > 4 && j < 13) {
            Grid toBeAdded = new Grid(xPos, yPos, color(0, 255, 0));
            toBeAdded.border = color(19, 19, 19);
            overallCoordinates[i][j] = toBeAdded;
          }
          else if (i > 11 && i < 17 && j > 5 && j < 12) {
            Grid toBeAdded = new Grid(xPos, yPos, color(0, 0, 255));
            toBeAdded.border = color(19, 19, 19);
            overallCoordinates[i][j] = toBeAdded;
          }
          else {
            Grid toBeAdded = new Grid(xPos, yPos, color(52, 141, 224));
            toBeAdded.border = color(19, 19, 19);
            overallCoordinates[i][j] = toBeAdded;
          }
        }
      }
    }
    else if (type == 1) {
      for (int i = 0; i < overallCoordinates.length; i++) {
        for (int j = 0; j < overallCoordinates[i].length; j++) {
          int xPos = 30 * j;
          int yPos = 30 * i;
          if (i < 2 || i > 25 || j < 2 || j > 15 || (i > 12 && i < 15)) {
            Grid toBeAdded = new Grid(xPos, yPos, color(0, 0, 0));
            toBeAdded.border = color(19, 19, 19);
            overallCoordinates[i][j] = toBeAdded;
          }
          else {
            Grid toBeAdded = new Grid(xPos, yPos, color(0, 0, 0));
            toBeAdded.border = color(19, 19, 19);
            overallCoordinates[i][j] = toBeAdded;
          }
      }
    }
  }
}
}
