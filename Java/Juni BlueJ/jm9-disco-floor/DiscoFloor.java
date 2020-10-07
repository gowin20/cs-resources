/*
******************************
* File 1: DiscoFloor applet
******************************
*/

import java.awt.*;
import java.applet.*;
import java.awt.event.*;

public class DiscoFloor extends Applet implements Runnable
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
           
           int r = (int)(Math.random() * 256);
           int gr = (int)(Math.random() * 256);
           int b = (int)(Math.random() * 256);
           Color c = new Color(r,gr,b);
           
           int row = (int)(Math.random()*20);
           int col = (int)(Math.random()*20);
           
           Block currBlock = new Block(row, col, c);
           grid[row][col] = currBlock;
               
           repaint();
           
           try {
                Thread.sleep(10);
           }
           catch (Exception e) {}
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