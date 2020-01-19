# 🌥 Weather App
iPhone Weather App using custom UICollectionViewFlowLayout and OpenWeather API

## Introduction
Weather app brings today’s weather and weekly weather data for current location using **OpenWeather API**.  
It will show the layout inspired by the **iPhone preinstalled Weather app**.

## How does it work
### 🌝 Data source 
If you clone this project, You will need to sign up for **OpenWeather** and get a API key to use for free. Then, put your key in `Info.plist`.  

According to **OpenWeather**, free accounts can access **Current Weather** and **5 day / 3 hour forecast** data.  
Therefore, use Current Weather to show the summarized current weather, and use the 5 day / 3 hour forecast to show today's weather and weekly weather. 

Learn the examples of API call and response and follow the simple steps on https://openweathermap.org/api.
	
### 🌚 Layout  
In this project, there are two important files for iPhone weather layout.  

&nbsp;&nbsp;&nbsp;&nbsp;**WeatherLayoutAttributes.swift**  
&nbsp;&nbsp;&nbsp;&nbsp;**WeatherLayout.swift**   

**WeatherLayoutAttributes** is a subclass of `UICollectionViewLayoutAttributes` and stores all the information about implementation of visual effects.

**WeatherLayout.swift** is a subclass of the abstract class `UICollectionViewFlowLayout` and defines all the properties you'll need to perform the layout calculations. Furthermore, it transforms visual attributes and implements following visual effects:
  
1. Make the **WeatherHeaderView** sticky and shrinking using `contentOffset.y`.  
2. Add a sticky effect to **TodayWeatherCell** using `CGAffineTransform`.
3. Implement a parallax effect on **WeatherHeaderView**.
