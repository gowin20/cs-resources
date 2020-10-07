import java.awt.*;

public class FirstTrain extends Train
{
    private boolean hasChimney;
    private boolean hasWindow;

    public FirstTrain(int x, int y, Color c, boolean chimney, boolean window) {
        super(x, y, c, 1);
        hasChimney = chimney;
        hasWindow = window;
    }

    public void draw(Graphics g) {
        super.draw(g);
        
        if (hasChimney) {
            g.setColor(Color.black);
            g.fillRect(this.getx()+20, this.gety()-20, 10, 20);
        }
        
        if (hasWindow) {
            g.setColor(Color.black);
            g.fillRect(this.getx()+15, this.gety()+10, 15, 15);
        }
    }
}
