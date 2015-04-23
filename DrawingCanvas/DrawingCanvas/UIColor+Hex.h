//
//  UIColor+Hex.h
//  DrawingCanvas
//
//  Created by Dylan Sturgeon on 4/21/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *) colorFromHexString: (NSString*) hex;
+ (UIColor *) colorFromHex: (NSInteger)hex;

@end
