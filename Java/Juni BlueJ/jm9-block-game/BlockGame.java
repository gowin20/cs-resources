import java.awt.*;
import java.applet.*;
import java.awt.event.*;

public class BlockGame extends Applet implements KeyListener, Runnable
{
    Block[][] grid = new Block[20][20];
    Block currBlock;
    Thread t = null;
    int sleepTime = 300;
    public void start()
    {
        t = new Thread(this);
        t.start();
    }
    
    public void init()
    {
        setBackground(Color.black);
        addKeyListener(this);
    }
    
    
    public boolean filledRow(int rowToCheck) {
        for (int c = 0; c < 20; c++) {
            if (grid[rowToCheck][c] == null) return false;
        }
        return true;
    }
    
    public void shiftGrid(int amount) {
        
        for (int r = 19; r >= 0; r--) {
            for (int c = 0; c < 20; c++) {
                
                if (r != 19) {
                    Block thisBlock = grid[r][c];
                    if (thisBlock != null) {
                        thisBlock.setRow(r+1);
                    }
                    grid[r+1][c] = thisBlock;
               }
               grid[r][c] = null;
            }
        }
    }
    
    public void run()
    {
       while (true) {
           // create new Block
           int r = (int)(Math.random() * 256);
           int gr = (int)(Math.random() * 256);
           int b = (int)(Math.random() * 256);
           Color c = new Color(r,gr,b);
           
           int row = 0;
           int col = (int)(Math.random()*20);
           
           currBlock = new Block(row, col, c);
           grid[row][col] = currBlock;
           
           // have the Block continue falling until it hits the bottom or another Block
           while (true) {
               int currRow = currBlock.getRow();
               int currCol = currBlock.getCol();
               
               // check if Block has hit the bottom
               if ((currRow == 19) || (grid[currRow+1][currCol] != null)) {
                   sleepTime = 300;
                   break;
               }               
               // drop Block down by one row
               else {
                   grid[currRow][currCol] = null;
                   grid[currRow+1][currCol] = currBlock;
                   currBlock.setRow(currRow+1);
               }

               repaint();
               try {
                    Thread.sleep(sleepTime);
               }
               catch (Exception e) {}
               
               if (filledRow(19)) {
                   shiftGrid(1);
                   repaint();
                }
            }
       }
    }
    
    public void keyPressed(KeyEvent e)
    {
       int key = e.getKeyCode();
        
       int currRow = currBlock.getRow();
       int currCol = currBlock.getCol();
       if (key == KeyEvent.VK_SPACE) {
           sleepTime = 10;
        }
       // check if block can be moved to left
       if (key == KeyEvent.VK_LEFT && currCol != 0 && grid[currRow][currCol-1] == null) {
            grid[currRow][currCol] = null;
            grid[currRow][currCol-1] = currBlock;
            currBlock.setCol(currCol-1);
       }
       
       // check if block can be moved to right
       else if (key == KeyEvent.VK_RIGHT && currCol != 19 && grid[currRow][currCol+1] == null) {
            grid[currRow][currCol] = null;
            grid[currRow][currCol+1] = currBlock;
            currBlock.setCol(currCol+1);
       }
       
       repaint();
    }
    
    public void keyReleased (KeyEvent e) {}
    
    public void keyTyped (KeyEvent e) {}
    
    public void paint(Graphics g) {
       for (Block[] row : grid) {
            for (Block b : row) {
                if (b != null)
                {
                    g.setColor(b.getColor());
                    g.fillRect(b.getCol() * 20 + 10, b.getRow() * 20 + 10, 20, 20);
                }
            }
       }
    }
}