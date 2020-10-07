import java.awt.*;
import java.applet.*;
import java.awt.event.*;

public class BlockGame extends Applet implements KeyListener, Runnable
{
    Block[][] grid = new Block[20][20];
    Block currBlock;
    Thread t = null;
    
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
               if (currRow == 19) {
                   break;
               }
               
               // check if there is another Block below this Block
               else if (grid[currRow+1][currCol] != null) {
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
                    Thread.sleep(50);
               }
               catch (Exception e) {}
            }
       }
    }
    
    public void keyPressed(KeyEvent e)
    {
       int key = e.getKeyCode();
        
       int currRow = currBlock.getRow();
       int currCol = currBlock.getCol();
       
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