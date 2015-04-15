//
//  ForecastTableViewCell.h
//  AdaptiveWeather
//
//  Created by Dylan Sturgeon on 4/14/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@end
