//2017-11-03
//kaitlynn chan
//tic tac toe - server

import processing.net.*;

Server myServer;

String myMsg, theirMsg;
int[][] board = new int [3][3];

final int EMPTY = 0;
final int X = 1;
final int O = 2;

PImage xpic, opic;

void setup() {
  size(300, 350);
  myServer = new Server(this, 1234);
  xpic = loadImage("x.png");
  opic = loadImage("o.png");
  background(#FC9D9A);
  textAlign(CENTER);
}

void draw() {
  listening();
  background(#FC9D9A);

  //board design
  fill(#FE4365);
  stroke(#FE4365);
  strokeWeight(5);
  line(100, 10, 100, 290);
  line(200, 10, 200, 290);
  line(10, 100, 290, 100);
  line(10, 200, 290, 200);
  rect(0, 300, width, 50);
  fill(255);
  textSize(25);
  text("Rematch", width/2, 330);


  int r = 0;
  int c = 0;
  while (r < 3) {
    //setup
    if (board[r][c] == EMPTY) {
    }
    if (board[r][c] == X) {
      image(xpic, c*100, r*100, 100, 100);
    }
    if (board[r][c] == O) {
      image(opic, c*100, r*100, 100, 100);
    }
    c++;
    if (c > 2) {
      c = 0;
      r++;
    }

    //are you winning
    if (board[0][c] == X  && board[1][c] == X && board[2][c] == X || board[0][0] == X  && board[0][1] == X && board[0][2] == X || board[1][0] == X  && board[1][1] == X && board[1][2] == X || board[2][0] == X  && board[2][1] == X && board[2][2] == X || board[0][0] == X  && board[1][1] == X && board[2][2] == X || board[0][2] == X  && board[1][1] == X && board[2][0] == X) {
      fill(255);
      textSize(50);
      text("X wins", width/2, height/2);
    } else if (board[0][c] == O  && board[1][c] == O && board[2][c] == O || board[0][0] == O  && board[0][1] == O && board[0][2] == O || board[1][0] == O  && board[1][1] == O && board[1][2] == O || board[2][0] == O  && board[2][1] == O && board[2][2] == O || board[0][0] == O  && board[1][1] == O && board[2][2] == O || board[0][2] == O  && board[1][1] == O && board[2][0] == O) {
      fill(255);
      textSize(50);
      text("O wins", width/2, height/2);
    } else if (board[0][0] != EMPTY && board[1][0] != EMPTY && board[2][0] != EMPTY && board[0][1] != EMPTY && board[1][1] != EMPTY && board[2][1] != EMPTY && board[0][2] != EMPTY && board[1][2] != EMPTY && board[2][2] != EMPTY) {
      fill(255);
      textSize(50);
      text("tie", width/2, height/2);
    }
  }
}


void mouseReleased() {
  //clicking
  int row = mouseY/100;
  int col = mouseX/100;
  if (mouseY < 300) {
    if (board[row][col] == EMPTY && board[row][col] != O && board[row][col] != X) {
      board[row][col] = X;
      myServer.write(row + "," + col);
    }
  }

  //restaring
  if (mouseX > 0 && mouseX < width && mouseY > 300 && mouseY < height) {
    reset();
    println(EMPTY);
    myServer.write(4 + "," + 4);
  }
}

void listening() {
  Client cl = myServer.available();
  if ( cl != null) {
    theirMsg = cl.readString();
    String[] coordinates = theirMsg.split(",");
    int R = int(coordinates[0]);
    int C = int(coordinates[1]);
    if (R == 4 && C == 4) {
      reset();
    } else {
      board[R][C] = O;
    }
    println(theirMsg);
  }
}

void reset() {
  int rclear = 0;
  int cclear = 0;
  while (rclear < 3) {
    background(#FC9D9A);
    board[rclear][cclear] = EMPTY;
    cclear++;
    if (cclear > 2) {
      cclear = 0;
      rclear++;
    }
  }
}