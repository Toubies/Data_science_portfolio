# Portfolio 
This repository includes all my data science/data analyst projects. The data come from kaggle.com or was extracted from a website by web scraping.

Projects with plotly visualizations can be opened by (https://nbviewer.org/)

## Python:
- #### EDA Denver Crimes
  - Data source: https://www.kaggle.com/paultimothymooney/denver-crime-data (access: 6 November)
  - Description: This datasets contains criminal/traffic cases for the City and County of Denver from 2016 to 2021. The data is based on the National Incident Based Reporting System (NIBRS) and it's updated regullary. Data used in this project was downloaded on 6th November 2021
  - Task details: Performing EDA for the dataset. Checking the most dangerous areas, density for all crimes and specific categories. Analyzing the hours and days of crimes.
  - Libraries used: pandas, numpy, matplolib, seaborn, plotly
- #### Animal classification
  - Data source: https://www.kaggle.com/uciml/zoo-animal-classification 
  - Description: Data contains 101 zoo animals from 7 different class. Most of the data are binary features which give the information if animal has or doesn't have the specific feature like fins, feathers, backbone.
  - Task details: Creating a model of classification and predict the class of new animals. 
  - Libraries used: pandas, numpy, matplolib, seaborn, networkx, sklearn
- #### Otodom properties
  - Data source: Scraped from Otodom.pl for Rzeszow (October 2021)
  - Description: Data contains various features of flats in Rzeszow like price, surface, heating, localization, number of rooms etc.
  - Task details: Creating a model of regression to predict price of new properties based on the historical data. Testing few models of regression and calculating the metrics for each model like absolute error, root mean squared error etc.
  - Libraries used: BeautifulSoup,requests,pandas,numpy, matplotlib, seaborn, plotly, geopy, sklearn, tensorflow
- #### Lending club 
  - Data source: https://www.kaggle.com/wordsforthewise/lending-club (access: October 2021)
  - Description: Dataset which has Lending Club loans from 2007 to 2018. Data contains various features like annual income, loan amount, interest rate etc.
  - Task details: Creating a model of classification to predict if customer will pay a loan or not and clusterization
  - Libraries used: pandas,numpy, matplotlib, seaborn, plotly, sklearn
- #### Rice Images
  - Data source: https://www.kaggle.com/mkoklu42/rice-image-dataset (access: 3 March 2022)
  - Description: The dataset consists 75000 rice grain images from 5 classes (Arborio, Basmati, Ipsala, Jasmine and Karacadag) in 5 directories. Each class has 15000 records in size 250x250.
  - Task details: Features extraction in Computer Vision. Using OpenCV library to extract data from each image such as eccentricity, major and minor axes, distances between extreme points, colors in each channels and length of countours. After the feature extraction, creating a dataframe with all features and performing an EDA, then building a classification model.
  - Libraries used: pandas,numpy, matplotlib, seaborn, plotly, sklearn, os, math, OpenCV
- #### Sentiment analysis (movies)
  - Data source: https://www.kaggle.com/yasserh/imdb-movie-ratings-sentiment-analysis (access: 3 March 2022) [in progress]
  - Description: The dataset has 40000 records of movie reviews labbeled as 1 and 0 (negative or positive review).
  - Task details: Cleaning the data and creating a model based on the RNN architecture, which will classify review as positive or negative.
  - Libraries used: pandas, numpy, matplotlib, seaborn, nltk, spaCy, wordcloud, re, tensorflow
  
## SQL:
- #### US Baby Names
  - Data source: https://www.kaggle.com/kaggle/us-baby-names (access: 18 December 2021)
  - Description: Data contains all names from 1880 to 2014 for USA on national and state level.
  - Task details: Data analysis with queries in sql and visualizations in seaborn and plotly
  - Libraries used: pandas,numpy, matplotlib, seaborn, plotly, BeautifulSoup, requests, selenium
- #### European Soccer Database
  - Data source: https://www.kaggle.com/hugomathien/soccer (access: 7 March 2022)
  - Description: The database contains 7 tables with records about European football such as matches, teams and players.
  - Task details: Creating league table for Poland Ekstraklasa, checking player's skills, adding new columns and updating the existing data. It was done to practice writing queries/subqueries, joining tables and creating views
  
