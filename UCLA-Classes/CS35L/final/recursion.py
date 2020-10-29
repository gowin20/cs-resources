


#RECURSION?????


#a RECURSIVE program is one that calls itself



def foo():

    print("hi")

    foo()


def iterate(string, ind):
    
    if (ind == len(string)):
        return

    print("IN:",ind,"Letter:",string[ind])

    iterate(string, ind+1)

    print("OUT:",ind,"Letter:",string[ind])



name = "spongebob"


iterate(name,0)

