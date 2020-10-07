#use any programming language you like

#input: arbitrary ascii text in standard input
#series of bytes, each 0..127

#output: lists every word in the input, one word per line
#each word prefaced by the count of the number of times it was found, sorted in decreasing count order

#word: a maximal sequence of characters in the set A-Za-z. No numbers or anything else.
#numbers and other non-alphabetic characters are not words










text = input("Input any ascii text, as much as you like: ")

"""
Example Input:
Four score and 7 and seven and seven and seven yuears ago, many years ago in fact, our fathers decided to fight a futile war against the greatest power in the worldaoidhfasdfiogdhaioshf NICE M4Ke mickey mousehha aledihsd
"""

length = 0
start = 0
wordFreq = {}

for letter in text:

    if letter.isalpha():
        length += 1
    else:
        word = text[start:(start+length)]

        if word != "":
            if word in wordFreq:
                wordFreq[word] += 1
            else:
                wordFreq[word] = 1
        start = start + length + 1
        length = 0


print(wordFreq)
