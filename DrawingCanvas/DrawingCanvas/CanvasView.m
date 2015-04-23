//
//  CanvasView.m
//  DrawingCanvas
//
//  Created by Dylan Sturgeon on 4/21/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "CanvasView.h"
#import "SelectableView.h"

@interface CanvasView ()
@property (nonatomic, strong) NSMutableArray *boxes;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *dragGesture;

@property (nonatomic, assign) CGSize boxSize;
@end

@implementation CanvasView

- (void)awakeFromNib {
    self.boxSize = CGSizeMake(50, 50);
    self.boxes = [[NSMutableArray alloc]init];
    [self addObserver:self forKeyPath:@"shapeCornerRadius" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"shapeFillColor" options:NSKeyValueObservingOptionNew context:nil];
    
    self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    self.dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    self.dragGesture.minimumNumberOfTouches = 2;
    self.dragGesture.maximumNumberOfTouches = 2;
    
    [self addGestureRecognizer:self.tapGesture];
    [self addGestureRecognizer:self.dragGesture];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void) dragged: (UIGestureRecognizer*) sender {
    assert(sender == self.dragGesture);
    
    CGPoint translation = [self.dragGesture translationInView:self];
    [self.dragGesture setTranslation:CGPointZero inView:self];
    
    for (SelectableView *box in self.boxes){
        if (box.isSelected) {
            [box translate:translation layout:NO];
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self setNeedsLayout];
    }];
}

- (void) tapped: (UIGestureRecognizer*) sender {
    assert(sender == self.tapGesture);
    
    CGPoint tappedPoint = [sender locationInView:self];
    
    CGRect boxFrame = CGRectMake(tappedPoint.x - (self.boxSize.width /2 ), tappedPoint.y - (self.boxSize.height / 2), self.boxSize.width, self.boxSize.height);
    
    SelectableView *newbox = [[SelectableView alloc] initWithFrame:boxFrame];
    newbox.shapeDelegate = self;
    
    [self.boxes addObject:newbox];
    [self addSubview:newbox];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([[change objectForKey:NSKeyValueChangeNewKey] isEqual:[NSNull null]]) {
        return;
    } else {
        [self notifyBoxesOfPropertyChange];
    }
}

-(void) notifyBoxesOfPropertyChange {
    for(SelectableView* box in self.boxes){
        [box notifyShapeDataChanged];
    }
}

#pragma mark ShapeDataDelegate
- (CGFloat)cornerRadius{
    return self.shapeCornerRadius;
}

- (CGFloat)borderWidth {
    return 5;
}

- (UIColor *)fillColor {
    return self.shapeFillColor;
}

- (UIColor *)borderColor {
    return [UIColor redColor];
}


@end
