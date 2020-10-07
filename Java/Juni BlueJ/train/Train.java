import java.awt.*; 

public class Train
{
    private int xStart;
    private int yStart;
    private Color color;
    private int numCarts;

    public Train(int x, int y, Color c, int n) {
        xStart = x;
        yStart = y;
        color = c;
        numCarts = n;
    }

    public void draw(Graphics g) {
        int xCurr = xStart;
        
        for (int i = 0; i < numCarts; i++) {
            g.setColor(color);
            g.fillRect(xCurr, yStart, 100, 50);
            g.setColor(Color.black);
            g.fillOval(xCurr + 10, yStart + 40, 20, 20);
            g.fillOval(xCurr + 70, yStart + 40, 20, 20);
            xCurr += 120;
        }
    }
    
    public int getx() {
        return xStart;
    }
    
    public int gety() {
        return yStart;
    }
}
