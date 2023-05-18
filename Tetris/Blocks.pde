/*
Pranjal Modi - Tetris Final Project
This class aims to represent the various blocks utilized in tetris, along with
containing various functionalities related to their use (such as rotation and
position).
*/
import java.util.*;
class Blocks {
  public ArrayList<PVector> coords;
  private final int[][][][] blockTypes = {
    { // L Shaped
      {
        {1, 0, 0},
        {1, 0, 0},
        {1, 1, 0}
      },
      {
        {1, 1, 1},
        {1, 0, 0},
        {0, 0, 0}
      },
      {
        {0, 1, 1},
        {0, 0, 1},
        {0, 0, 1}
      },
      {
        {0, 0, 0},
        {0, 0, 1},
        {1, 1, 1}
      }
    },
    { // J Shaped
      {
        {0, 0, 1},
        {0, 0, 1},
        {0, 1, 1}
      },
      {
        {0, 0, 0},
        {1, 0, 0},
        {1, 1, 1}
      },
      {
        {1, 1, 0},
        {1, 0, 0},
        {1, 0, 0}
      },
      {
        {1, 1, 1},
        {0, 0, 1},
        {0, 0, 0}
      }
    },
    { // T Shaped
      {
        {0, 0, 0},
        {1, 1, 1},
        {0, 1, 0}
      },
      {
        {0, 1, 0},
        {1, 1, 0},
        {0, 1, 0}
      },
      {
        {0, 1, 0},
        {1, 1, 1},
        {0, 0, 0}
      },
      {
        {0, 1, 0},
        {0, 1, 1},
        {0, 1, 0}
      }
    },
    { // S Shaped
      {
        {0, 1, 1},
        {1, 1, 0}
      },
      {
        {1, 0},
        {1, 1},
        {0, 1}
      },
      {
        {1, 1, 0},
        {0, 1, 1}
      },
      {
        {0, 1},
        {1, 1},
        {1, 0}
      }
    },
    { // Z Shaped
      {
        {0, 0, 0},
        {1, 1, 0},
        {0, 1, 1}
      },
      {
        {0, 1, 0},
        {1, 1, 0},
        {1, 0, 0}
      },
      {
        {1, 1, 0},
        {0, 1, 1},
        {0, 0, 0}
      },
      {
        {0, 0, 1},
        {0, 1, 1},
        {0, 1, 0}
      }
    },
    { // O Shaped
      {
        {1, 1},
        {1, 1}
      }
    },
    { // I Shaped
      {
        {1},
        {1},
        {1},
        {1}
      }
    }
  };
  public int[][] curBlock;
  public int rotationState;
  public int block;
  public int leftmostXGrid;
  public int leftmostYGrid;
  // Constructor(s)
  public Blocks(int block, int rotationState) {
    this.block = block;
    this.rotationState = rotationState;
    curBlock = blockTypes[block][rotationState];
  }
  public Blocks(int block, int rotationState, int leftmostXGrid, int leftmostYGrid) {
    this.block = block;
    this.rotationState = rotationState;
    curBlock = blockTypes[block][rotationState];
    this.leftmostXGrid = leftmostXGrid;
    this.leftmostYGrid = leftmostYGrid;
  }
  public Blocks(/* Random Constructor*/) {
    this.block = (int) (7 * Math.random());
    this.rotationState = 0;
    leftmostXGrid = (int) (Math.random() * 8);
    leftmostYGrid = -2;
    curBlock = blockTypes[block][rotationState];
  }
  // Methods
  void rotateB(int dir) {
    if (block < 5) {
      int oldRotation = rotationState;
      rotationState += dir;
      if (rotationState > 3) {
        rotationState = 0;
      }
      if (rotationState < 0) rotationState = 3;
      if (blockTypes[block][rotationState][0].length > blockTypes[block][oldRotation][0].length) leftmostXGrid--;
      else if (blockTypes[block][rotationState][0].length < blockTypes[block][oldRotation][0].length) leftmostXGrid++;
      curBlock = blockTypes[block][rotationState];
    }
    if (block == 6) {
      rotationState += dir;
      if (rotationState > 1) rotationState = 0;
      if (rotationState < 0) rotationState = 1;
    }
  }
  
  void update() {
    coords = new ArrayList<PVector>();
    for (int i = 0; i < curBlock.length; i++) {
      for (int j = 0; j < curBlock[i].length; j++) {
        if (curBlock[i][j] == 1) {
          coords.add(new PVector(leftmostXGrid + j, leftmostYGrid + i));
        }
      }
    }
  }
  
  color shapeToColor() {
    color[] colors = {color(221, 10, 178), color(255, 200, 46), color(254, 251, 52), color(83, 218, 63), color(1, 237, 250), color(0, 119, 211), color(253, 63, 89)};
    return colors[block];
  }
  
  
}
