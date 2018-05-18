#include <stdio.h>

int main (void)
{
    int x=25, y=70;
    int value;
    extern int test1(int,int,int);
    
    value=test1(x,y,5);
    printf ("Result=%d\n",value);
    return 0;
    
}
