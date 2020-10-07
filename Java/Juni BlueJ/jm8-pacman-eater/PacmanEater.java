import java.awt.*;
import java.applet.*;
import java.awt.event.*;

public class PacmanEater extends Applet implements KeyListener
{
    int xPacMan = 250;
    int yPacMan = 250;
    int xBall = 50;
    int yBall = 50;
    int score = 0;
    int arcStart = 45;

    public void init()
    {
        setBackground(Color.black);
        addKeyListener(this);
    }
    
    public void keyPressed(KeyEvent e)
    {
        int key = e.getKeyCode();
        if (key == KeyEvent.VK_DOWN)
        {
            yPacMan += 10;
            arcStart = 315;
        }
        else if (key == KeyEvent.VK_UP)
        {
            yPacMan -= 10;
            arcStart = 135;
        }
        else if (key == KeyEvent.VK_LEFT)
        {
            xPacMan -= 10;
            arcStart = 225;
        }
        else if (key == KeyEvent.VK_RIGHT)
        {
            xPacMan += 10;
            arcStart = 45;
        }
        repaint();
    }
    
    public void keyReleased (KeyEvent e) {}
     
    public void keyTyped (KeyEvent e) {}

    public void paint(Graphics g) {
        g.setColor(Color.yellow);
        g.fillArc(xPacMan, yPacMan, 50, 50, arcStart, 270);
        
        int xPacManCenter = xPacMan + 25;
        int yPacManCenter = yPacMan + 25;
        int xBallCenter = xBall + 15;
        int yBallCenter = yBall + 15;
        if (Math.abs(xPacManCenter - xBallCenter) < 10 && Math.abs(yPacManCenter - yBallCenter) < 10)
        {
            xBall = (int)(Math.random()*500);
            yBall = (int)(Math.random()*500);
            score++;
        }
        
        g.setColor(Color.red);
        g.fillOval(xBall, yBall, 30, 30);
        g.setColor(Color.white);
        g.drawString("Score: " + Integer.toString(score), 20, 20);
    }
}