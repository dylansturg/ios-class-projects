//
//  WeatherForecast.h
//  AdaptiveWeather
//
//  Created by Dylan Sturgeon on 4/14/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherForecast : NSObject
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSDateComponents *sunriseTime;
@property (copy, nonatomic) NSDateComponents *sunsetTime;

+ (instancetype)weatherForecastWithContentsOfDictionary: (NSDictionary*) dict;
- (instancetype)initWithContentsOfDictionary: (NSDictionary*) dict;

-(NSInteger) temperatureForDateTime:(NSDateComponents*) dateTime;
-(NSInteger) temperatureForHour:(NSInteger) hourOfDay;

-(NSString*) formattedSunsetTime;
-(NSString*) formattedSunriseTime;

@end
