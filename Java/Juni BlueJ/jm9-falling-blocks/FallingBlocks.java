import java.awt.*;
import java.applet.*;
import java.awt.event.*;

public class FallingBlocks extends Applet implements Runnable
{
    Block[][] grid = new Block[20][20];
    Thread t = null;
    
    public void start()
    {
        t = new Thread(this);
        t.start();
    }
    
    public void init()
    {
        setBackground(Color.black);
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
           
           Block currBlock = new Block(row, col, c);
           grid[row][col] = currBlock;
           
           // have the Block continue falling until it hits the bottom or another Block
           while (true) {
               // check if Block has hit the bottom
               if (row == 19) {
                   break;
               }
               
               // check if there is another Block below this Block
               else if (grid[row+1][col] != null) {
                   break;
               }
               
               // drop Block down by one row
               else {
                   grid[row][col] = null;
                   grid[row+1][col] = currBlock;
                   currBlock.setRow(row+1);
               }
               
               // increment row
               row += 1;
               
               repaint();
               try {
                    Thread.sleep(100);
               }
               catch (Exception e) {}
            }
       }
    }
    
    public void paint(Graphics g) {
       for (Block[] row : grid) {
            for (Block b : row) {
                if (b != null) {
                    g.setColor(b.getColor());
                    g.fillRect(b.getCol() * 20 + 10, b.getRow() * 20 + 10, 20, 20);
                }
            }
       }
    }
}