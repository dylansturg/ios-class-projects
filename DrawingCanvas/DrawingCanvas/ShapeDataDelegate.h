//
//  ShapeDataDelegate.h
//  DrawingCanvas
//
//  Created by Dylan Sturgeon on 4/21/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShapeDataDelegate <NSObject>

- (CGFloat) cornerRadius;
- (CGFloat) borderWidth;
- (UIColor*) fillColor;
- (UIColor*) borderColor;

@end
