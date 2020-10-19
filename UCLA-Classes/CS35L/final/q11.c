#include <stdio.h>

typedef struct {
    int x;
    int y;
} Point;

Point *create_point() {
    Point p;
    p.x = 0;
    p.y = 0;
    return &p;
}

int main() {
    Point *p = create_point();
    printf("(x,y) = (%d, %d)\n", p->x, p->y);
    return 0;
}