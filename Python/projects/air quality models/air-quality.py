import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.dates as pltdates
import matplotlib.ticker as ticker
import pandas as pd
import numpy as np
import requests

from datetime import datetime as dt

#air quality report graph that's updated hourly - website!

#get all cities, number of measurements



#Converts a date string to a matplotlib date
def convert_date(date):
  #convert ISO date to datetime object
  date = dt.strptime(date,'%Y-%M-%d')
  #convert datetime objects to matplotlib dates
  date = pltdates.date2num(date)
  return date


"""
response = requests.get("https://api.openaq.org/v1/locations",params={'country':'US','city':'Minneapolis'})

data = response.json()
for city in data['results']:
  print(city)
"""

response = requests.get("https://api.openaq.org/v1/measurements",params={'city':'Buffalo','country':'US','parameter':'o3','limit':10000})

data = response.json()

if not data['results']:
  print("Error: no results found")
  exit()



time_value = {'dates':[],'values':[]}

values = []

date = ""
print(len(data['results']))
for point in data['results']:
  curr_date = point['date']['local'][0:10]
  #print(curr_date)

  if date == "":
    date = curr_date

  if curr_date == date:
    values.append(point['value'])
  #  time_value
  else:
    #encode into dictionary
    average_val = sum(values) / len(values)

    #date = convert_date(date)
    time_value['dates'].append(date)
    time_value['values'].append(average_val)
    
    #reset
    date = curr_date
    values = []

average_val = sum(values) / len(values)

#convert ISO date to datetime object

#date = convert_date(date)
time_value['dates'].append(date)
time_value['values'].append(average_val)

#print(time_value)

#x = all the dates

#y = for each date, a list of numbers
#print(time_value)
  #print(point['date']['local'])
#  time_value[point['date']['local']] = point['value']




time_data = pd.DataFrame(data=time_value)



#print(time_data["dates"])



dim = (12,10)
fig,ax = plt.subplots(figsize=dim)
graph = sns.lineplot(x="dates",y="values",data=time_data,ax=ax)


time_data = time_data.rolling(7).mean()


tick_spacing = 10

ax.xaxis.set_major_locator(ticker.MultipleLocator(tick_spacing))

plt.savefig('asheville_air.png')
