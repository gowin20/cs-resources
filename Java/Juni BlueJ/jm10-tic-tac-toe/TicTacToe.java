import java.awt.*;
import java.applet.Applet;
import java.awt.event.*;

public class TicTacToe extends Applet implements MouseListener
{
    String[][] grid = new String[3][3];
    String currPlayer = "x";
    boolean canPlay = true;
    
    public void init()
    {
        addMouseListener(this);
    }
    public void mouseClicked (MouseEvent e) {}
    public void mouseEntered (MouseEvent e) {}
    public void mouseExited (MouseEvent e) {}
    public void mousePressed (MouseEvent e) {
        if (canPlay) {
            int x = e.getX();
            int y = e.getY();
            
            int row = x/100;
            int col = y/100;
            
            if (row >= 0 && row < 3 && col >= 0 && col < 3 && grid[row][col] == null) {
                grid[row][col] = currPlayer;
                
                if (currPlayer == "x") {
                    currPlayer = "o";
                } else {
                    currPlayer = "x";
                }
            }
            
            repaint();
        }
    }
    public void mouseReleased (MouseEvent e) {}
    
    public void paint(Graphics g)
    {
        // draw the board
        g.fillRect(0,0,300,300);
        g.setColor(Color.white);
        g.drawLine(0,100,300,100);
        g.drawLine(0,200,300,200);
        g.drawLine(100,0,100,300);
        g.drawLine(200,0,200,300);
        
        // fill in the Xs and Os
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                if (grid[i][j] != null) {
                    g.drawString(grid[i][j], i*100 + 50, j*100 + 50);
                }
            }
        }
        
        // check for win or tie
        g.setColor(Color.black);
        
        // check the rows
        for (int i = 0; i < 3; i++) {
            if(grid[i][0] == "x" && grid[i][1] == "x" && grid[i][2] == "x") {
                g.drawString("x wins!", 125, 320);
                canPlay = false;
            } else if (grid[i][0] == "o" && grid[i][1] == "o" && grid[i][2] == "o") {
                g.drawString("o wins!", 125, 320);
                canPlay = false;
            }
        }
        
        // check the columns
        for (int j = 0; j < 3; j++) {
            if(grid[0][j] == "x" && grid[1][j] == "x" && grid[2][j] == "x") {
                g.drawString("x wins!", 125, 320);
                canPlay = false;
            } else if (grid[0][j] == "o" && grid[1][j] == "o" && grid[2][j] == "o") {
                g.drawString("o wins!", 125, 320);
                canPlay = false;
            }
        }
        
        // check the diagonals
        if (grid[0][0] == "x" && grid[1][1] == "x" && grid[2][2] == "x"){
            g.drawString("x wins!", 125, 320);
            canPlay = false;
        } else if (grid[0][0] == "o" && grid[1][1] == "o" && grid[2][2] == "o"){
            g.drawString("o wins!", 125, 320);
            canPlay = false;
        }
        
        if (grid[2][0] == "x" && grid[1][1] == "x" && grid[0][2] == "x"){
            g.drawString("x wins!", 125, 320);
            canPlay = false;
        } else if (grid[2][0] == "o" && grid[1][1] == "o" && grid[0][2] == "o"){
            g.drawString("o wins!", 125, 320);
            canPlay = false;
        }
        
        // check for tie
        if (canPlay) {
            int numSelected = 0;
            for (int i = 0; i < 3; i++) {
                for (int j = 0; j < 3; j++) {
                    if (grid[i][j] != null) {
                        numSelected++;
                    }
                }
            }
            
            if (numSelected == 9) {
                g.drawString("It's a tie!", 125, 320);
                canPlay = false;
            }
        }
        
    }
}
