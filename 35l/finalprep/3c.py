def numDigits(n):
    ln = len(str(n))
    if n < 0:
        ln -= 1
    return ln

#print(numDigits(-1),numDigits(-10000),numDigits(10))

def isArmstrong(n):

    if n == 0:
        return "No"
    num_dig = numDigits(n)
    num = str(n)
    total = 0
    for dig in num:
        try:
            total += (int(dig) ** num_dig)
        except ValueError:
            print("Error: please input a positive number")
            return "No"

    if total == n:
        return "Yes"

    return "No"


n = int(input())
print("Is", n, "an Armstrong number?", isArmstrong(n))  