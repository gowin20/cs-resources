import java.awt.*;
import java.applet.*;
import java.awt.event.*;

public class PacManEaterAnimated extends Applet implements KeyListener, Runnable
{
    int xPacMan = 250;
    int yPacMan = 250;
    int xBall = 50;
    int yBall = 50;
    int score = 0;
    int arcStart = 45;
    boolean mouthOpen = false;
    Thread t = null;

    public void init()
    {
        setBackground(Color.black);
        addKeyListener(this);
    }
    
    public void start()
    {
        t = new Thread(this);
        t.start();
    }
    
    public void run()
    {
        while (true)
        {
            mouthOpen = !mouthOpen;
            
            if (arcStart == 315)
                yPacMan += 10;
            else if (arcStart == 135)
                yPacMan -= 10;
            else if (arcStart == 225)
                xPacMan -= 10;
            else if (arcStart == 45)
                xPacMan += 10;
            repaint();
            try {
                Thread.sleep(100);
            }
            catch (Exception e) {}
        }
    }
    
    public void keyPressed(KeyEvent e)
    {
        int key = e.getKeyCode();
        if (key == KeyEvent.VK_DOWN)
        {
            arcStart = 315;
        }
        else if (key == KeyEvent.VK_UP)
        {
            arcStart = 135;
        }
        else if (key == KeyEvent.VK_LEFT)
        {
            arcStart = 225;
        }
        else if (key == KeyEvent.VK_RIGHT)
        {
            arcStart = 45;
        }
        repaint();
    }
    
    public void keyReleased (KeyEvent e) {}
    
    public void keyTyped (KeyEvent e) {}

    public void paint(Graphics g) {
        g.setColor(Color.yellow);
        if (mouthOpen) {
            g.fillArc(xPacMan, yPacMan, 50, 50, arcStart, 270);
        } else {
            g.fillArc(xPacMan, yPacMan, 50, 50, 0, 360);
        }
        
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