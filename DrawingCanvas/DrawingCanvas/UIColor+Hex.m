//
//  UIColor+Hex.m
//  DrawingCanvas
//
//  Created by Dylan Sturgeon on 4/21/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorFromHex:(NSInteger)hex {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 \
                    green:((float)((hex & 0x00FF00) >>  8))/255.0 \
                     blue:((float)((hex & 0x0000FF) >>  0))/255.0 \
                           alpha:1.0];
}

+ (UIColor *)colorFromHexString:(NSString *)hex {
    assert([hex length] == 6 || [hex length] == 7);
    
    NSScanner *numScanner = [NSScanner scannerWithString:hex];
    if ([hex hasPrefix:@"#"]) {
        [numScanner setScanLocation:1];
    }
    
    unsigned hexValue = 0;
    if (![numScanner scanHexInt:&hexValue]){
        return [UIColor blackColor];
    }
    
    return [UIColor colorFromHex:hexValue];
}

@end
