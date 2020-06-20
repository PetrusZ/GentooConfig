#!/usr/bin/python3

import sys
import time
from pyowm import OWM
from datetime import datetime

API_key = '2033a6613824285f9da7bc278b55de50'
unit = 'celsius'

owm = OWM(API_key)
reg = owm.city_id_registry()
weather_mgr = owm.weather_manager()
weather = weather_mgr.weather_at_place('Shizuishan, CN').weather
currrent_temp = weather.temperature('celsius')["temp"]

forecast = weather_mgr.forecast_at_place('Shizuishan, CN', '3h')

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
        temp = weather.temperature(unit)['temp']
        status = weather.status
        print(status + ' ' + str(temp))
        #  print(weather.reference_time('iso'))
    elif sys.argv[1] == '2day':
        temp = forecast_1day.temperature(unit)['temp']
        status = forecast_1day.status
        print(status + ' ' + str(temp))
        #  print(forecast_1day.reference_time('iso'))
    elif sys.argv[1] == '3day':
        temp = forecast_2day.temperature(unit)['temp']
        status = forecast_2day.status
        print(status + ' ' + str(temp))
        #  print(forecast_2day.reference_time('iso'))
