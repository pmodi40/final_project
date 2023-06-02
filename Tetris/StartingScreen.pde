class StartingScreen {
  Grid[][] overallCoordinates = new Grid[28][18];
  int type;
  // Constructor
  public StartingScreen(int type) {
    for (int i = 0; i < overallCoordinates.length; i++) {
      for (int j = 0; j < overallCoordinates[i].length; j++) {
        int xPos = 30 * j;
        int yPos = 30 * i;
        this.type = type;
        /*
        Starting Screen Specs:
        Tetris Logo in the top-middle
        Highscore Display for EACH GAMEMODE
        Play Button -> Leads to screens with two diff animations for two diff modes
        */
      }
    }
  }
}
