import java.awt.*;
import java.applet.Applet;
import java.awt.event.*;

public class ClickCircle extends Applet implements MouseListener
{
    int x = 0;
    int y = 0;
    
    public void init()
    {
        addMouseListener(this);
    }
    public void mouseClicked (MouseEvent e)
    {
        x = e.getX();
        y = e.getY();
        repaint();
    }
    public void mouseEntered (MouseEvent e) {}
    public void mouseExited (MouseEvent e) {}
    public void mousePressed (MouseEvent e) {}
    public void mouseReleased (MouseEvent e) {}
    
    public void paint(Graphics g)
    {
        int r = (int)(Math.random()*256);
        int gr = (int)(Math.random()*256);
        int b = (int)(Math.random()*256);
        Color c = new Color(r,gr,b);
        g.setColor(c);
        
        int width = (int)(Math.random()*100);
        
        g.fillOval(x-width/2, y-width/2, width, width);
    }
}
