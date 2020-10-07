import java.awt.*; 

public class PacMan
{
    private int xStart;
    private int yStart;
    private int size;
    private Color color;

    public PacMan(int x, int y, int s, Color c) {
        xStart = x;
        yStart = y;
        size = s;
        color = c;
    }

    public void draw(Graphics g) {
        g.setColor(color);
        g.fillArc(xStart, yStart, size, size, 220, 270);
    }
    
    public int getx() {
        return xStart;
    }
    
    public int gety() {
        return yStart;
    }
    
    public int getSize() {
        return size;
    }
}