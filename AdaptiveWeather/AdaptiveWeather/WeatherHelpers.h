//
//  WeatherHelpers.h
//  HWAdaptiveWeather
//
//  Created by Tim Ekl on 2015.01.31.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const WeatherDataCityNameKey;
extern NSString * const WeatherDataTemperaturesKey;
extern NSString * const WeatherDataSunriseTimeKey;
extern NSString * const WeatherDataSunsetTimeKey;

@interface NSDate (WeatherExtensions)

+ (NSInteger)currentHour;

@end

@interface NSDictionary (WeatherExtensions)

+ (instancetype)weatherDataWithContentsOfPlistNamed:(NSString *)plistName;

@end
