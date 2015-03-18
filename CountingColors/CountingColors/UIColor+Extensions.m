//
//  UIColor+Extensions.m
//  HWCountingColors
//
//  Created by Tim Ekl on 5/25/13.
//  Copyright (c) 2013 Tim Ekl. All rights reserved.
//

#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

+ (UIColor *)randomRGBColor;
{
    CGFloat red = (float)arc4random_uniform(256) / 256.0f;
    CGFloat green = (float)arc4random_uniform(256) / 256.0f;
    CGFloat blue = (float)arc4random_uniform(256) / 256.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

@end
