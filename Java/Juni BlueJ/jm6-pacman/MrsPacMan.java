import java.awt.*; 

public class MrsPacMan extends PacMan
{
    private Color bowColor;

    public MrsPacMan(int x, int y, int s, Color c, Color bc) {
        super(x, y, s, c);
        bowColor = bc;
    }

    public void draw(Graphics g) {
        super.draw(g);
        g.setColor(bowColor);
        int xStart = super.getx();
        int yStart = super.gety();
        int size = super.getSize();
        
        g.drawLine(xStart+size/2-10, yStart, xStart+size/2-10, yStart+10);
        g.drawLine(xStart+size/2+10, yStart, xStart+size/2+10, yStart+10);
        g.drawLine(xStart+size/2-10, yStart+10, xStart+size/2+10, yStart);
        g.drawLine(xStart+size/2+10, yStart+10, xStart+size/2-10, yStart);
    }
}
