//
//  ViewController.m
//  AdaptiveWeather
//
//  Created by Dylan Sturgeon on 4/14/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "WeatherHelpers.h"
#import "WeatherForecast.h"
#import "ForecastTableViewCell.h"
#import "WeatherViewController.h"

@interface WeatherViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UITableView *forecastTable;
@property (weak, nonatomic) IBOutlet UILabel *sunriseLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *prevForecastButton;
@property (weak, nonatomic) IBOutlet UIButton *nextForecastButton;

@property (strong, nonatomic) NSArray* availableCities;
@property (nonatomic) NSInteger forecastHours;
@property (strong, nonatomic) WeatherForecast *currentForecast;
@property (assign, nonatomic) NSInteger currentCityIndex;

@property (strong, nonatomic) NSCalendar *currentCalendar;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation WeatherViewController

NSString *cellId = @"ForecastCell";
NSString *tempFormat = @"%ld °F";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.forecastTable.delegate = self;
    self.forecastTable.dataSource = self;
    
    self.forecastTable.rowHeight = 30;
    self.forecastTable.bounces = NO;
    self.forecastTable.userInteractionEnabled = NO;
    
    self.currentCalendar = [NSCalendar currentCalendar];
    self.dateFormatter = [[NSDateFormatter alloc]init];
    [self.dateFormatter setDateFormat:@"h:mm a"];
    
    self.currentCityIndex  = 0;
    self.availableCities = @[@"chicago", @"seattle", @"newyork"];
    self.forecastHours = 4;
    
    [self updateForecast];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    CGFloat rowHeight = tableView.rowHeight;
    
    self.tableViewHeightConstraint.constant = rowHeight * self.forecastHours;
    [tableView setNeedsUpdateConstraints];
    
    return self.forecastHours;
}

- (void) updateForecast {
    
    NSDictionary *weatherData = [NSDictionary weatherDataWithContentsOfPlistNamed:self.availableCities[self.currentCityIndex]];
    WeatherForecast *forecast = [WeatherForecast weatherForecastWithContentsOfDictionary:weatherData];
    
    self.currentForecast = forecast;
    
    self.sunriseLabel.text = [self.currentForecast formattedSunriseTime];
    self.sunsetLabel.text = [self.currentForecast formattedSunsetTime];
    
    NSInteger currentTemperature = [self.currentForecast temperatureForHour:[NSDate currentHour]];
    self.temperatureLabel.text = [NSString stringWithFormat:tempFormat, (long) currentTemperature];
    
    self.cityLabel.text = [self.currentForecast city];
    
    if (self.currentCityIndex == 0) {
        self.prevForecastButton.enabled = NO;
    } else {
        self.prevForecastButton.enabled = YES;
    }
    
    if(self.currentCityIndex >= (self.availableCities.count - 1)){
        self.nextForecastButton.enabled = NO;
    } else {
        self.nextForecastButton.enabled = YES;
    }
    
}

- (IBAction)prevTapped:(id)sender {
    if(self.currentCityIndex == 0){
        return;
    }
    
    self.currentCityIndex--;
    [self updateForecast];
}

- (IBAction)nextTapped:(id)sender {
    if(self.currentCityIndex >= self.availableCities.count){
        return;
    }
    
    self.currentCityIndex++;
    [self updateForecast];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ForecastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];

    NSInteger incrementedHour = [NSDate currentHour] + indexPath.row + 1; // no need to show current
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setHour:incrementedHour];
    
    // Could just take the hour mod 24, but that's no fun - what if someone tries to use this with a different calendar?
    NSDate *dateForCell = [self.currentCalendar dateFromComponents:comps];
    NSInteger hourForCell = [self.currentCalendar component:NSCalendarUnitHour fromDate:dateForCell];
    NSInteger tempForCell = [self.currentForecast temperatureForHour:hourForCell];
    
    NSString* time = [self.dateFormatter stringFromDate:[self.currentCalendar dateFromComponents:comps]];
    cell.timeLabel.text = time;
    cell.tempLabel.text = [NSString stringWithFormat:@"%ld °F", (long)tempForCell];
    
    return cell;
}


@end
