import json
import os
import pandas as pd
from bs4 import BeautifulSoup

folder = os.path.dirname(os.path.abspath(__file__))
recipe_file = os.path.join(folder, 'recipes.json')

source = open(recipe_file)
data = json.load(source)
recipe_database = pd.DataFrame({
    "Author":data["Author"],
    "Ingredients":data["Ingredients"],
    "Instructions":data["Instructions"],
    "prep_time":data["prep_time"],
    "cook_time":data["cook_time"],
    "total_time":data["total_time"]
},index=data["Title"])
source.close()


#prints the ingredients of a recipe
def make_ingredients(recipe):

    ingredient_list = "Ingredients:\n"
    for ingredient in recipe["Ingredients"]:
        ingredient_list += ingredient["original_text"] + "\n"
    
    recipe["Ingredients"] = ingredient_list
    return ingredient_list


#given a recipe database object, creates a good-looking set of "instructions" for it
def make_steps(recipe):
    instructions = recipe["Instructions"]
    instructions = instructions.split("<li>")

    instruction_string = "Instructions\n"
    for i in range(1,len(instructions)):

        soup = BeautifulSoup(instructions[i],features="html.parser")
        text = soup.get_text()
        instruction_string += (str(i)+": "+text + "\n")

    recipe["Instructions"] = instruction_string
    return instruction_string



#returns a list of all rows containing a certain string in their title
def query_recipe_titles(query):
    results = []
    for index,row in recipe_database.iterrows():
        name = index.lower()
        if query in name:
            results.append(row)
    return results


#prints out the titles of a list of recipes
def print_titles(lst):
    for i in lst:
        print(i.name)


#given html, returns a normal version of the text without any tags
def clean_html(html):
    soup = BeautifulSoup(html,features="html.parser")
    text = soup.get_text()
    return text




#cbd = query_recipe_titles("cbd")
weed = query_recipe_titles("cannabis")
#print_titles(cbd)
#print_titles(weed)
#oil = query_recipe_titles("oil")
#print_titles(oil)



#clean up the recipe database
for index,recipe in recipe_database.iterrows():
    make_ingredients(recipe)
    make_steps(recipe)


for recipe in weed:
    print(recipe.name)
    print(recipe["Ingredients"])
    print(recipe["Instructions"])