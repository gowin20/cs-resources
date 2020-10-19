import java.awt.*;
import java.applet.Applet;

public class BasicShapes extends Applet
{
    public void paint(Graphics g) {
        // fillRect() takes in x, y, width, height
        g.setColor(Color.red);
        g.fillRect(50, 50, 100, 100);
        
        // fillOval() takes in x, y, width, height
        g.setColor(Color.cyan);
        g.fillOval(200, 50, 100, 100);
        
        // fillArc() takes in x, y, width, height, startAngle, arcAngle
        g.setColor(Color.green);
        g.fillArc(50, 200, 100, 100, 90, 270);
        
        // colors: https://docs.oracle.com/javase/7/docs/api/java/awt/Color.html
    }
}
