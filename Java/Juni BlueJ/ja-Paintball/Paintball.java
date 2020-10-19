import java.awt.*;
import java.applet.Applet;

public class Paintball extends Applet
{
    public void paint(Graphics g) {
        int x1 = 0;
        int y1 = 0;
        
        int x2 = 250;
        int y2 = 0;
        
        for (int i = 0; i <= 10; i++)
        {
            g.setColor(Color.pink);
            g.fillOval(x1, y1, 25, 25);
            g.fillOval(x2, y2, 25, 25);
            
            x1 += 25;
            y1 += 25;
            
            x2 -= 25;
            y2 += 25;
        }
    }
}