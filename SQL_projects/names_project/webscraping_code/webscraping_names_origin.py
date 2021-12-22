from bs4 import BeautifulSoup as bs
import requests
import pandas as pd
import time
import collections
from selenium import webdriver
from pathlib import Path
# loading selenium driver
path = Path(r'/home/user/selenium-firefox/drivers/geckodriver')
browser = webdriver.Firefox(executable_path=path)

names_dict = collections.defaultdict(list)

# saving url where we will check names
main_url = 'https://www.thebump.com/b/baby-name-origins#A'


r = requests.get(main_url)
soup = bs(r.content,"html.parser")

urls = soup.findAll('a', {'class':'jsx-3517084426 content-box'})

def save_name(names, origin):
    for name in names:
        names_dict['Name'].append(name.text)
        names_dict['Origin'].append(origin)

for url in urls:
    names_page = 'https://www.thebump.com' + url.get('href')
    # opening url with names
    browser.get(names_page)
    time.sleep(10)
    # grabing names and origin
    while True:
        time.sleep(6)
        names = browser.find_elements_by_class_name('jsx-3985190551.name')
        if names[0].text not in names_dict['Name']:
            try:
                print('heh')
                origin = browser.find_element_by_class_name('jsx-26869251.text').text.split()[0]
            except:
                try:
                    origin = browser.find_element_by_class_name('jsx-1429963401.text').text.split()[0]
                except:
                    print('Error ' + (names_page))
            # using function to save names and origin into dictionary
            save_name(names, origin)
            time.sleep(4)
            try:
                browser.find_element_by_class_name('jsx-3724733679.next').click()
            except:
                break
        else:
            break
    time.sleep(3)
df = pd.DataFrame()
df['Name'] = names_dict['Name']
df['Origin'] = names_dict['Origin']

def replace_origin(row):
    if (row['Origin'] in ['Irish','Gaelic','Celtic']):
        return 'Irish/Gaelic/Celtic'
    elif (row['Origin'] in ['Finnish','Swedish','Norwegian','Norse','Danish']):
        return 'Scandinavian'
    elif (row['Origin'] in ['Russian','Polish','Czech']):
        return 'Slavic'
    elif (row['Origin'] in ['Swahili','Ghanaian','Nigerian']):
        return 'African'
    elif (row['Origin'] in ['Sanskrit']):
        return 'Indian'
    elif (row['Origin'] in ['Cambodian','Korean','Vietnamese','Chinese','Japanese']):
        return 'East Asian'
    elif (row['Origin'] in ['Aramaic','Hebrew']):
        return 'Aramaic/Hebrew'
    elif (row['Origin'] in ['Babylonian','Egyptian','Turkish','Yiddish']):
        return 'Others'
    elif (row['Origin'] in ['Spanish','Portuguese','Basque']):
        return 'Iberian'
    elif (row['Origin'] in ['Dutch','German']):
        return 'Dutch/German'
    else:
        return row['Origin']

df_clear = df.copy()

df_clear['Origin'] = df.apply(lambda row: replace_origin(row),axis=1)
df_clear.to_csv('NamesOrigin.csv')
