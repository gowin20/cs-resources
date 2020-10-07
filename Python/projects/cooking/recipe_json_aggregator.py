import requests
import pandas as pd
import json
#print(data)

recipes = {"Title":[],"Author":[],"Ingredients":[],"Instructions":[],"prep_time":[],"cook_time":[],"total_time":[],}




for i in range(1,500):
  result = requests.get("https://emilykylenutrition.com/wp-json/mv-create/v1/creations/"+str(i))
  data = result.json()
  print("recipe",i)
  
 # print(data)
  if "code" not in data:
    recipes["Title"].append(data["title"])
    recipes["Author"].append(data["author"])
    recipes["Ingredients"].append(data["supplies"])
    recipes["prep_time"].append(data["prep_time"])
    recipes["Instructions"].append(data["instructions"])
    recipes["cook_time"].append(data["active_time"])
    recipes["total_time"].append(data["total_time"])
  else:
    print("skipping recipe",i)


with open("recipes.json", "w") as outfile:
  json.dump(recipes,outfile)

#recipes_database.to_json("recipes.csv")



recipes_database = pd.DataFrame(data=recipes)
print(recipes_database)
