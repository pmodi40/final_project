/**
Pranjal Modi - Tetris Final Project
*/
class Grid {
    public color curColor;
    public int leftXCor;
    public int leftYCor;
    public color border = color(0, 0, 0);
    public boolean filled = false;
    public boolean nameZone = false;
    public boolean scoreZone = false;
    public boolean nextZone = false;
    public boolean endZone = false;
    public boolean pauseZone = false;
    public boolean borderZone = false;
    // Constructor(s)
    public Grid(int leftXCor, int leftYCor, color curColor) {
        this.leftXCor = leftXCor;
        this.leftYCor = leftYCor;
        this.curColor = curColor;
    }
    // Methods
    void setColor(color newColor) {
        curColor = newColor;
    }
}
