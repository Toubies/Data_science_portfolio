from bs4 import BeautifulSoup as bs
import requests
import pandas as pd
import numpy as np
import time

# Link with flats which we want to analyze
link_base = r'https://www.otodom.pl/pl/oferty/sprzedaz/mieszkanie/rzeszow?distanceRadius=5&limit=72&page='
# page link
link = link_base + '1'

#DataFrame (to store our data)
df = pd.DataFrame()

# request
r = requests.get(link)
soup = bs(r.content,"html.parser")

# count pages
# - select number of ads
adds_no = soup.find_all('span', {'class': 'css-klxieh e1ia8j2v3'})[0].get_text()

# calculate number of pages - limit 72
pages = np.ceil(int(adds_no)/72)

# list of attributes
feature_list = ['Powierzchnia','Liczba pokoi','Rynek','Rodzaj zabudowy','Piętro',
                  'Liczba pięter','Materiał budynku','Ogrzewanie','Rok budowy',
                  'Stan wykończenia','Miejsce parkingowe','Czynsz']
# creating dictionary to store values
import collections
feature_dict = collections.defaultdict(list)

# function which add none values to attributes
def check_attributes(list_feature):
    for attribute in feature_list:
        if attribute in list_feature:
            continue
        else:
            feature_dict[attribute].append(np.nan)
            
# Grab data from all available pages(iterate by pages)
for page in range(2, int(pages)+1):
    
    #processing
    # -get articles
    articles = soup.find_all('ul',{'class': 'css-14cy79a e3x1uf06'})[1].select('article')
    
    hrefs = ['https://www.otodom.pl'+ href['href'] for href in soup.find_all('a', {'class': 'css-19ukcmm es62z2j29'})][3::]
    
    # lists for data
    
    # iterating through adds on current page
    for article_no, article_href in enumerate(hrefs):
        try:
            # opening the article
            r = requests.get(article_href)
            soup = bs(r.content,"html.parser")
            
            #Grab offer title(article), URL and localization
            feature_dict['title'].append(articles[article_no].find_all('h3',{'class': 'css-1873em4 es62z2j25'})[0].get_text())
            feature_dict['URL'].append(article_href)
            feature_dict['Localization'].append(articles[article_no].p.span.get_text())

            #Grabing the price
            feature_dict['price'].append(soup.select_one('strong', {'class': 'css-b114we e2nnfee14'}).get_text())
            
            list_used_feature = []
            features_dir = soup.find_all('div', {'class': 'css-o4i8bk ev4i3ak2'})
            
            for feature in features_dir:
                if (feature.get_text()[0:len(feature.get_text())-1] in feature_list) is True:
                    feature_dict[str(feature.get_text())[0:len(feature.get_text())-1]].append(feature.findNext('div').get_text())
                    list_used_feature.append(feature.get_text()[0:len(feature.get_text())-1])
            check_attributes(list_used_feature)
        except:
            #update message
            print('Error| Page: ',str(page-1),' article_href',article_href)
        time.sleep(0.15)
    
    # update link, go to next page
    time.sleep(3)
    link = link_base + str(page)
    r = requests.get(link)
    soup = bs(r.content)
    
    if page>pages:
        break

df['title'] = feature_dict['title']
df['URL'] = feature_dict['URL']
df['localization'] = feature_dict['Localization']
df['surface'] = feature_dict['Powierzchnia']
df['price'] = feature_dict['price']
df['rent'] = feature_dict['Czynsz']
df['parking'] = feature_dict['Miejsce parkingowe']
df['num_of_rooms'] = feature_dict['Liczba pokoi']
df['building_material'] = feature_dict['Materiał budynku']
df['heating'] = feature_dict['Ogrzewanie']
df['floor'] = feature_dict['Piętro']
df['num_of_floors'] = feature_dict['Liczba pięter']
df['market'] = feature_dict['Rynek']
df['year'] = feature_dict['Rok budowy']
df['type_of_building'] = feature_dict['Rodzaj zabudowy']
df['condition'] = feature_dict['Stan wykończenia']

df.to_csv('OtoDom_data_01_october_rzeszow.csv')
