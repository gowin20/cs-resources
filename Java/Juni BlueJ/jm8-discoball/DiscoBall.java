import java.awt.*;
import java.applet.*;
import java.awt.event.*;

public class DiscoBall extends Applet implements Runnable
{
    int r = 0;
    int gr = 0;
    int b = 0;
    Thread t = null;
    
    public void start()
    {
        t = new Thread(this);
        t.start();
    }
    
    public void run()
    {
        while (true)
        {
            r = (int)(Math.random()*256);
            gr = (int)(Math.random()*256);
            b = (int)(Math.random()*256);
            repaint();
            
            try {
                Thread.sleep(100);
            }
            catch (Exception e) {}
        }
    }
    public void paint(Graphics g) {
        Color c = new Color(r,gr,b);
        g.setColor(c);
        g.fillOval(200,200,100,100);
    }
}