//
//  ViewController.h
//  CheckIn
//
//  Created by Dylan Sturgeon on 4/29/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController
- (void) addCheckInPlace: (CLPlacemark*)place;

@end

