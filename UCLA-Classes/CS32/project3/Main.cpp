#include "Game.h"
#include <iostream>

using namespace std;

int main()
{
	HumanPlayer hp("george");
	BadPlayer daniel("daniel");
	BadPlayer bp2("bart");

	SmartPlayer shreya("shreyaaa");


	Board b(6, 4);

//	for (int i = 1; i <= b.holes(); i++)
//		b.setBeans(NORTH, i, 0);

	Game minigame(b, &shreya, &hp);

	minigame.play();

}