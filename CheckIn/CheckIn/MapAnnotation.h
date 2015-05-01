//
//  MapAnnotation.h
//  CheckIn
//
//  Created by Dylan Sturgeon on 5/1/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (strong, nonatomic) CLPlacemark *placemark;

@end
