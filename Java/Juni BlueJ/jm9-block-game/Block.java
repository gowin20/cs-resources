
/*
******************************
* File 2: Block Class
******************************
*/

import java.awt.*;

public class Block
{
    private int row;
    private int col;
    private Color color;

    public Block(int r, int cl, Color c)
    {
        row = r;
        col = cl;
        color = c;
    }

    public int getRow() {
        return row;
    }
    
    public void setRow(int r) {
        row = r;
    }
    
    public int getCol() {
        return col;
    }
    
    public void setCol(int cl) {
        col = cl;
    }
    
    public Color getColor() {
        return color;
    }
}