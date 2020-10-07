import java.awt.*;
import java.applet.*;

public class PacManMain extends Applet
{
    public void paint(Graphics g) {
        int x = 0;
        int y = 100;
        int size = 100;
        
        for (int i = 0; i < 5; i++) {
            PacMan p = new PacMan(x, y, size, Color.yellow);
            p.draw(g);
            x += 200;
            size += 25;
        }
        
        x = 0;
        y = 300;
        size = 100;
        
        for (int i = 0; i < 5; i++) {
            MrsPacMan p = new MrsPacMan(x, y, size, Color.blue, Color.red);
            p.draw(g);
            x += 200;
            size += 25;
        }
    }
}
