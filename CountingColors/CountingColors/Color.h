//
//  Color.h
//  CountingColors
//
//  Created by Dylan Sturgeon on 3/20/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Color : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * pressedCount;
@property (nonatomic, retain) NSNumber * sessionPressedCount;

@end
