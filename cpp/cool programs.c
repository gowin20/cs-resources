#include <iostream>
#include <string>
#include <algorithm>
using namespace std;

string decToBinary(int n);
unsigned int calculateHammingDistance(unsigned int smaller, unsigned int larger);

int main()
{
	int number1;
	int number2;
	cout << "enter smaller number: ";
	cin >> number1;
	cout << "enter larger number: ";
	cin >> number2;
	cout << "Hamming Distance is " << calculateHammingDistance(number1, number2) << endl;


}

string decToBinary(int n)
{
	int binaryNum;
	string binary;
	while (n > 0) {
		binaryNum = n % 2;
		n = n / 2;
		binary += to_string(binaryNum);
	}
	reverse(binary.begin(), binary.end());
	return binary;
}

unsigned int calculateHammingDistance(unsigned int smaller, unsigned int larger)
{
	string small = decToBinary(smaller);
	string large = decToBinary(larger);
	while (small.size() != large.size())
		small.insert(0, "0");
	cout << small << " " << large << endl;
	int distance = 0;
	for (int i = 0; i != large.size(); i++)
	{
		if (small[i] != large[i])
		{
			distance += 1;
		}
	}
	return distance;
}




Matrix Multiplication:


int A[N];
int B[N][N];
int C[N];

for (j = 0; j < N; j++)
{
	sum = 0
	for (i = 0; i < N; i++)
		sum += A[i] * B[j][i];
	C[j] = sum;
}















