
/**
 * Write a description of class Smiley here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.awt.*;
import java.applet.Applet;

public class HappyGraphics extends Applet
{
    public void paint(Graphics g) {
        // smiley face
        g.fillRect(200, 25, 10, 100);
        g.fillRect(300, 25, 10, 100);
        g.fillArc(100, 100, 300, 150, 180, 180);
        
        // pac men
        g.setColor(Color.yellow);
        g.fillArc(100, 300, 150, 150, 50, 270);
        g.fillArc(250, 300, 150, 150, 220, 270);
    }
}
