//
//  CheckInViewController.h
//  CheckIn
//
//  Created by Dylan Sturgeon on 4/30/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CheckInViewController : UITableViewController
@property (strong, nonatomic) CLLocation *location;
@end
