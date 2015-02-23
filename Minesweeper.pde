//Yufan X. AP Comp Sci. Minesweeper
import de.bezier.guido.*;
public final static int NUM_ROWS = 30;
public final static int NUM_COLS = 30;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined 
private ArrayList <MSButton> messageSpace = new ArrayList <MSButton>(); //ArrayList of buttons for highlighting winning&losing messages
private boolean gameOver=false;
private boolean win = false;
void setup ()
{
  size(600, 600);
  textAlign(CENTER, CENTER);  
  // make the manager
  Interactive.make( this ); 
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r=0; r<NUM_ROWS; r++)
  {
    for (int c=0; c<NUM_COLS; c++)
    {
      buttons[r][c] = new MSButton(r, c);
    }
  }
  setBombs();
}
public void setBombs()
{
  while (bombs.size ()<88)
  {
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if (!bombs.contains(buttons[row][col]))
    {
      bombs.add(buttons[row][col]);
    }
  }
}

public void draw ()
{
  if (isWon())
  {
    displayWinningMessage();
  }
}

public boolean isWon()
{
  for (int r = 0; r < NUM_ROWS; r++)
    for (int c = 0; c < NUM_COLS; c++)   
        if(!bombs.contains(buttons[r][c]) && !buttons[r][c].isClicked())
          return false;
  return true;
}
public void displayLosingMessage()
{
  gameOver=true;
  for (int r=0; r<NUM_ROWS; r++)
    for (int c=0; c< NUM_COLS; c++)
      if (bombs.contains(buttons[r][c]))
        buttons[r][c].setLabel("B");

  String message = new String("Game Over! Try Again");
  for (int i = 0; i < message.length (); i++ )
  {
//    buttons[(NUM_ROWS/2)-1][i+5].clicked = true;
    if (!messageSpace.contains(buttons[(NUM_ROWS/2)-1][i+5]))
        {
          messageSpace.add(buttons[(NUM_ROWS/2)-1][i+5]);
        }
    buttons[(NUM_ROWS/2)-1][i+5].clicked = true;
    buttons[(NUM_ROWS/2)-1][i+5].marked=false;
    buttons[(NUM_ROWS/2)-1][i+5].setLabel(message.substring(i, i+1));
  }
}
public void displayWinningMessage()
{
  win=true;
  for (int r=0; r<NUM_ROWS; r++)
    for (int c=0; c<NUM_COLS; c++)
      bombs.remove(buttons[r][c]);
  String message = new String("You Win! Congratz!");
  for (int i = 0; i < message.length (); i++ )
  {
    buttons[(NUM_ROWS/2)-1][i+5].clicked = true;
     buttons[(NUM_ROWS/2)-1][i+5].marked=false;
    if (!messageSpace.contains(buttons[(NUM_ROWS/2)-1][i+5]))
      messageSpace.add(buttons[(NUM_ROWS/2)-1][i+5]);

    buttons[(NUM_ROWS/2)-1][i+5].setLabel(message.substring(i, i+1));
  }
}

public class MSButton
{
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton ( int rr, int cc )
  {
    width = 600/NUM_COLS;
    height = 600/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    marked = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isMarked()
  {
    return marked;
  }
  public boolean isClicked()
  {
    return clicked;
  }
  // called by manager

  public void mousePressed () 
  {
    if (gameOver) return;
    if (mouseButton==LEFT && !gameOver && !win && !isMarked())
      clicked = true;
    if (mouseButton==RIGHT && !gameOver && !win && !isClicked())
    {
      marked=!marked;
//      if (countBombs(r, c) == 0 || bombs.contains(this))
//        clicked = !clicked;
    }
    else if (bombs.contains(this) && !marked)
      displayLosingMessage();  
    else if (countBombs(r, c)>0 && !isMarked())
    {
      label = "" + countBombs(r, c);
     // clicked = true;
    }
    else if(countBombs(r,c)>0 && isMarked())
    {
      clicked=!clicked;
    }
    else
    {
      if (isValid(r, c-1) && !buttons[r][c-1].clicked)
        buttons[r][c-1].mousePressed();
      if (isValid(r, c+1) && !buttons[r][c+1].clicked)
        buttons[r][c+1].mousePressed();
      if (isValid(r-1, c) && !buttons[r-1][c].clicked)
        buttons[r-1][c].mousePressed();
      if (isValid(r+1, c) && !buttons[r+1][c].clicked)
        buttons[r+1][c].mousePressed();
      if (isValid(r-1, c-1) && !buttons[r-1][c-1].clicked)
        buttons[r-1][c-1].mousePressed();
      if (isValid(r+1, c+1) && !buttons[r+1][c+1].clicked)
        buttons[r+1][c+1].mousePressed();
      if (isValid(r+1, c-1) && !buttons[r+1][c-1].clicked)
        buttons[r+1][c-1].mousePressed();
      if (isValid(r-1, c+1) && !buttons[r-1][c+1].clicked)
        buttons[r-1][c+1].mousePressed();
    }
  }

  public void draw () 
  {    
    if (marked)
    {
      fill(0);
      ellipse(x+width/2, y+height/2, width/2, height/2); //black bombs
    } 
    else if (clicked && bombs.contains(this) && !messageSpace.contains(this))
    {
      fill(255, 0, 0);
      ellipse(x+width/2, y+height/2, width/2, height/2); //red bomb
    } else if (clicked && messageSpace.contains(this))
    {
      fill(0);
      rect(x, y, width, height);
    } else if (clicked) //dark colored button
    {
      fill(40, 13, 77);
      rect(x, y, width, height);
    } else
    {
      fill(222);
      rect(x, y, width, height);
    }

    if (gameOver && !win) //lost-->red labels
    {
      fill(255, 0, 0);
      text(label, x+width/2, y+height/2);
    } else if (!gameOver && win)//won-->light blue labels
    {
      fill(100, 255, 246);
      text(label, x+width/2, y+height/2);
    } else //still playing-->white labels
    {
      fill(255);
      text(label, x+width/2, y+height/2);
    }
  }

  public void setLabel(String newLabel)
  {
    label = newLabel;
  }
  public boolean isValid(int r, int c)
  {
    if (r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS)
      return true;

    return false;
  }
  public int countBombs(int row, int col)
  {
    int numBombs = 0;
    if (isValid(row-1, col) && bombs.contains(buttons[row-1][col]))
      numBombs++;
    if (isValid(row+1, col) && bombs.contains(buttons[row+1][col]))
      numBombs++;
    if (isValid(row, col-1) && bombs.contains(buttons[row][col-1]))
      numBombs++;
    if (isValid(row, col+1) && bombs.contains(buttons[row][col+1]))
      numBombs++;
    if (isValid(row+1, col-1) && bombs.contains(buttons[row+1][col-1]))
      numBombs++;
    if (isValid(row-1, col+1) && bombs.contains(buttons[row-1][col+1]))
      numBombs++;
    if (isValid(row+1, col+1) && bombs.contains(buttons[row+1][col+1]))
      numBombs++;
    if (isValid(row-1, col-1) && bombs.contains(buttons[row-1][col-1]))
      numBombs++;
    return numBombs;
  }
}

public void keyPressed()
{
    gameOver=false;
    win=false;
    for(int r=0; r<NUM_ROWS;r++)
      for(int c=0; c<NUM_COLS;c++)
        {
          bombs.remove(buttons[r][c]);
          messageSpace.remove(buttons[r][c]);
          buttons[r][c].marked=false;
          buttons[r][c].clicked=false;
          buttons[r][c].setLabel(" ");
        }
    setBombs(); 
  
}
