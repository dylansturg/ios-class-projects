//
//  CanvasView.h
//  DrawingCanvas
//
//  Created by Dylan Sturgeon on 4/21/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShapeDataDelegate.h"

@interface CanvasView : UIView <ShapeDataDelegate>

@property (nonatomic, strong) UIColor* shapeFillColor;
@property (nonatomic, assign) CGFloat shapeCornerRadius;

@end
