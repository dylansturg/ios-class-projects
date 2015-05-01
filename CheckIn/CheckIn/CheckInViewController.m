//
//  CheckInViewController.m
//  CheckIn
//
//  Created by Dylan Sturgeon on 4/30/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "CheckInViewController.h"
#import "MapViewController.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface CheckInViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) NSArray *placemarks;

@property (strong, nonatomic) CLPlacemark *selectedPlacemark;
@end

@implementation CheckInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.location = ((AppDelegate*) [[UIApplication sharedApplication] delegate]).lastKnownLocation;
    NSAssert(self.location != nil, @"Need a location to reverse geocode");
    
    self.geocoder = [[CLGeocoder alloc] init];
    [self.geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError *error) {
        self.title = @"Check In";
        if (!error) {
            self.placemarks = placemarks;
            [self.tableView reloadData];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // Called on Cancel
    
    MapViewController *mapVC = (MapViewController*) segue.destinationViewController;
    if (self.selectedPlacemark != nil) {
        [mapVC addCheckInPlace:self.selectedPlacemark];
    }
    
    if ([self.geocoder isGeocoding]){
        [self.geocoder cancelGeocode];
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedPlacemark = self.placemarks[indexPath.row];
    
    [self performSegueWithIdentifier:@"dismissCheckIn" sender:self];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.placemarks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GeoCell" forIndexPath:indexPath];
    CLPlacemark *placemark = self.placemarks[indexPath.row];
    cell.textLabel.text = placemark.name;
    
    return cell;
}

@end
