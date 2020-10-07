import java.awt.*;
import java.applet.Applet;
import java.awt.event.*;

public class BubbleMaker extends Applet implements MouseListener
{
    int[] x = new int[10];
    int[] y = new int[10];
    int[] size = new int[10];
    Color[] color = new Color[10];
    int counter = 0;
    
    public void init()
    {
        addMouseListener(this);
    }
    public void mouseClicked (MouseEvent e)
    {
        x[counter] = e.getX();
        y[counter] = e.getY();

        size[counter] = (int)(Math.random()*100);
        
        int r = (int)(Math.random()*256);
        int gr = (int)(Math.random()*256);
        int b = (int)(Math.random()*256);
        Color c = new Color(r,gr,b);
        color[counter] = c;
        
        counter++;
        if (counter == 10) {
            counter = 0;
        }
        
        repaint();
    }
    public void mouseEntered (MouseEvent e) {}
    public void mouseExited (MouseEvent e) {}
    public void mousePressed (MouseEvent e) {}
    public void mouseReleased (MouseEvent e) {}
    
    public void paint(Graphics g)
    {
        for (int i = 0; i < 10; i++) {
            g.setColor(color[i]);
            g.fillOval(x[i], y[i], size[i], size[i]);
        }
    }
}
