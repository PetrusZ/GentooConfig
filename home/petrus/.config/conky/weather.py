#!/usr/bin/python3

import sys
import time
from pyowm import OWM
from datetime import datetime

API_key = '2033a6613824285f9da7bc278b55de50'
unit = 'celsius'
lat = 39.23
lon = 106.77

owm = OWM(API_key)
observed = owm.weather_at_coords(lat, lon)
location = observed.get_location()
weather = observed.get_weather()

forecast = owm.three_hours_forecast(location.get_name())
cast = forecast.get_forecast()

localtime = time.localtime(time.time())
day_time = datetime(localtime.tm_year, localtime.tm_mon, localtime.tm_mday, 4,
                    0)
timestamp_noon = time.mktime(day_time.timetuple())

# 正午时间
day1_time = datetime.fromtimestamp(timestamp_noon + 60 * 60 * 24)
day2_time = datetime.fromtimestamp(timestamp_noon + 60 * 60 * 24 * 2)

forecast_1day = forecast.get_weather_at(day1_time)
forecast_2day = forecast.get_weather_at(day2_time)

if len(sys.argv) == 2:
    if sys.argv[1] == '1day':
        temp = weather.get_temperature(unit)['temp']
        status = weather.get_status()
        print(status + ' ' + str(temp))
    elif sys.argv[1] == '2day':
        temp = forecast_1day.get_temperature(unit)['temp']
        status = forecast_1day.get_status()
        print(status + ' ' + str(temp))
    elif sys.argv[1] == '3day':
        temp = forecast_2day.get_temperature(unit)['temp']
        status = forecast_2day.get_status()
        print(status + ' ' + str(temp))
