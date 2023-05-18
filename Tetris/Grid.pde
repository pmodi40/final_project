/**
Pranjal Modi - Tetris Final Project
*/
class Grid {
    public color curColor;
    public int leftXCor;
    public int leftYCor;
    public boolean filled = false;
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
