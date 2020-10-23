import java.awt.*;
import java.applet.Applet;
import java.util.Scanner;

public class WhichShape extends Applet
{
    
    public void paint(Graphics g) {
        String shape = "circle";

        if (shape.equals("circle"))
        {
            g.setColor(Color.cyan);
            g.fillOval(200, 200, 100, 100);
        }
        else if (shape.equals("square"))
        {
            g.setColor(Color.red);
            g.fillRect(200, 200, 100, 100);
        }
        else if (shape.equals("pacman"))
        {
            g.setColor(Color.yellow);
            g.fillArc(200, 200, 100, 100, 45, 270);
        }
    }
}