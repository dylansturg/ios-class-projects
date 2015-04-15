//
//  WeatherHelpers.m
//  HWAdaptiveWeather
//
//  Created by Tim Ekl on 2015.01.31.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "WeatherHelpers.h"

NSString * const WeatherDataCityNameKey = @"CityName";
NSString * const WeatherDataTemperaturesKey = @"Temperatures";
NSString * const WeatherDataSunriseTimeKey = @"SunriseTime";
NSString * const WeatherDataSunsetTimeKey = @"SunsetTime";

@implementation NSDate (WeatherExtensions)

+ (NSInteger)currentHour;
{
    return [[NSCalendar currentCalendar] component:NSCalendarUnitHour fromDate:[NSDate date]];
}

@end

@implementation NSDictionary (WeatherExtensions)

+ (instancetype)weatherDataWithContentsOfPlistNamed:(NSString *)plistName;
{
    return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]];
}

@end
