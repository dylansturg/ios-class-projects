//
//  WeatherForecast.m
//  AdaptiveWeather
//
//  Created by Dylan Sturgeon on 4/14/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "WeatherForecast.h"

@interface WeatherForecast()
@property (strong, nonatomic) NSArray* temperatures;
@property (copy, nonatomic) NSString* sunset;
@property (copy, nonatomic) NSString* sunrise;
@end

@implementation WeatherForecast

NSString *plistDateFormat = @"hh:mm a";
NSString *preferredDisplayDateFormat = @"h:mm a";

- (instancetype)initWithContentsOfDictionary:(NSDictionary *)dict{
    self = [super init];

    if(self){
        self.city = [dict objectForKey:@"CityName"];
        self.sunrise = [dict objectForKey:@"SunriseTime"];
        self.sunset = [dict objectForKey:@"SunsetTime"];
        
        NSDictionary* temps = [dict objectForKey:@"Temperatures"];
        NSMutableArray *tempsArray = [[NSMutableArray alloc]initWithCapacity:temps.count];
        
        for (int i=0; i < temps.count; i++) {
            [tempsArray addObject:[NSNull null]];
        }
        
        for(NSString* key in temps){
            NSInteger index = key.integerValue;
            NSInteger temp = ((NSString*) [temps objectForKey:key]).integerValue;
            
            [tempsArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger:temp]];
        }
        
        self.temperatures = [NSArray arrayWithArray:tempsArray];
    }
    
    return self;
}

+ (instancetype)weatherForecastWithContentsOfDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithContentsOfDictionary:dict];
}

-(NSInteger)temperatureForDateTime:(NSDateComponents *)dateTime{
    NSInteger hour = [dateTime hour];
    return [self temperatureForHour:hour];
}

- (NSInteger)temperatureForHour:(NSInteger)hourOfDay{
    assert(hourOfDay >= 0 && hourOfDay < self.temperatures.count);
    return ((NSNumber*)self.temperatures[hourOfDay]).integerValue;
}

- (NSString *)formattedSunriseTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:preferredDisplayDateFormat];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    return [formatter stringFromDate:[cal dateFromComponents:self.sunriseTime]];
}

- (NSString *)formattedSunsetTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:preferredDisplayDateFormat];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    return [formatter stringFromDate:[cal dateFromComponents:self.sunsetTime]];
}

- (NSDateComponents *)sunriseTime{
    return [self componentsForDateTimeString:self.sunrise units:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour];
}

- (NSDateComponents*) sunsetTime{
    return [self componentsForDateTimeString:self.sunset units:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour];
}

- (NSDateComponents*) componentsForDateTimeString: (NSString*) dateTimeString units:(NSCalendarUnit) units {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:plistDateFormat];
    
    NSDate *sunriseDate = [formatter dateFromString:dateTimeString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:units fromDate:sunriseDate];
    
    return components;
}

@end
