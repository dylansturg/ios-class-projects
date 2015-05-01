//
//  ViewController.m
//  CheckIn
//
//  Created by Dylan Sturgeon on 4/29/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "MapViewController.h"
#import "CheckInViewController.h"
#import "AppDelegate.h"
#import "MapAnnotation.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (assign, nonatomic) BOOL allowedShowUserLocation;
@property (assign, nonatomic) BOOL trackingUser;
@end

CGFloat MapSpanLat = 0.2;
CGFloat MapSpanLong = 0.2;

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.mapView.delegate = self;
    self.trackingUser = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self attemptShowUserLocation];
}

- (void)addCheckInPlace:(CLPlacemark *)place{
    MapAnnotation *annotation = [[MapAnnotation alloc] init];
    annotation.coordinate = place.location.coordinate;
    annotation.title = place.name;
    annotation.subtitle = [NSString stringWithFormat:@"%@, %@", place.locality, place.administrativeArea];
    
    [self.mapView addAnnotation:annotation];
}

- (IBAction)findMe:(id)sender {
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (IBAction)unwindFromCheckin:(UIStoryboardSegue*)segue{
    
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self attemptShowUserLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.lastKnownLocation = [locations lastObject];
}

#pragma mark - Private

- (void) followUser
{
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (void)attemptShowUserLocation
{
    if (![CLLocationManager locationServicesEnabled]) {
        return;
    }
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusDenied: // user declined permission
        case kCLAuthorizationStatusRestricted: // system doesn't allow location, e.g. corporate policy

            return;
            
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
            self.mapView.showsUserLocation = YES;
            [self.locationManager startUpdatingLocation];
            return;
            
        case kCLAuthorizationStatusNotDetermined:
                [self.locationManager requestWhenInUseAuthorization];
            break;
    }
}


@end
