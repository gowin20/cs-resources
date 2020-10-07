import java.awt.*;
import java.applet.*;

public class Main extends Applet
{
    public void paint(Graphics g) {
        FirstTrain ft1 = new FirstTrain(100, 100, Color.blue, true, true);
        Train t1 = new Train(220, 100, Color.blue, 5);
        t1.draw(g);
        ft1.draw(g);
        
        FirstTrain ft2 = new FirstTrain(150, 300, new Color(66, 134, 244), true, false);
        Train t2 = new Train(270, 300, new Color(66, 134, 244), 4);
        t2.draw(g);
        ft2.draw(g);
        
        FirstTrain ft3 = new FirstTrain(200, 500, new Color(204, 24, 191), true, true);
        Train t3 = new Train(320, 500, new Color(239, 155, 233), 3);
        t3.draw(g);
        ft3.draw(g);
    }
}
