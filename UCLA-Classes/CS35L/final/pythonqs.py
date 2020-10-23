
class FruitSalad:

    melons = ['watermelon', 'honeydew', 'cantaloupe']

    def __init__(self, fruits):
        self.fruits = fruits

    def add_fruits(self, new_fruits):
        self.fruits += new_fruits
        new_fruits = []


    def find_melons(self):
        melon_map = {}
        for fruit in self.fruits:
            if fruit in self.melons:
                melon_map[fruit] = self.fruits.index(fruit)
        return melon_map
    
    def remove_melons(self):
        #melon_map = self.find_melons()
        new_fruits = []
        for fruit in self.fruits:
            if fruit not in self.melons:
                new_fruits.append(fruit)
        return new_fruits

if __name__ == "__main__":
    x = ['apple', 'banana']
    y = ['strawberry', 'watermelon' ]#,'honeydew','blackberry','blueberry','cantaloupe']

    salad = FruitSalad(x)
    salad.add_fruits(y)


    print("Salad", salad.fruits)
    print(y)

    print(salad.find_melons())

    print("new list", salad.remove_melons())
    print("new salad", salad.fruits)