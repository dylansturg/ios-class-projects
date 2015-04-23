//
//  SelectableView.m
//  DrawingCanvas
//
//  Created by Dylan Sturgeon on 4/21/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "SelectableView.h"

@interface SelectableView ()
@property (nonatomic, strong) UITapGestureRecognizer *selectGesture;

#pragma mark Size Constraints
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

#pragma mark Position Constraints
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@property (nonatomic, strong) NSLayoutConstraint *leftConstraint;

@property (nonatomic, strong) NSLayoutConstraint *fixedInLeftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *fixedInRightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *fixedInTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *fixedInBottomConstraint;

@end

@implementation SelectableView

- (instancetype)init {
    if((self = [super init])){
        [self _SelectableView_commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])){
        [self _SelectableView_commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if((self = [super initWithCoder:aDecoder])){
        [self _SelectableView_commonInit];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"shapeDelegate"];
}

- (void) _SelectableView_commonInit {
    self.isSelected = NO;
    self.selectGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    [self addGestureRecognizer:self.selectGesture];
    
    self.widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50];
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50];
    
    self.widthConstraint.active = YES;
    self.heightConstraint.active = YES;
    
    [self addObserver:self forKeyPath:@"shapeDelegate" options:NSKeyValueObservingOptionNew context:nil];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([[change objectForKey:NSKeyValueChangeNewKey] isEqual:[NSNull null]]) {
        return;
    } else {
        [self notifyShapeDataChanged];
    }
}

+ (BOOL)requiresConstraintBasedLayout{
    return YES;
}

- (void)didMoveToSuperview {
    [self deactivatePositionConstraints];
    
    CGPoint origin = self.frame.origin;
    
    self.topConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:origin.y];
    self.topConstraint.priority = UILayoutPriorityDefaultHigh;
    
    self.leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:origin.x];
    self.leftConstraint.priority = UILayoutPriorityDefaultHigh;
    
    self.topConstraint.active = YES;
    self.leftConstraint.active = YES;
    
//    self.fixedInLeftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
//    self.fixedInLeftConstraint.priority = UILayoutPriorityDefaultHigh;
//    
//    self.fixedInRightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1 constant:0];
//    self.fixedInRightConstraint.priority = UILayoutPriorityDefaultHigh;
//    
//    self.fixedInTopConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
//    self.fixedInTopConstraint.priority = UILayoutPriorityDefaultHigh;
//    self.fixedInBottomConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
//    self.fixedInBottomConstraint.priority = UILayoutPriorityDefaultHigh;
//    
//    [NSLayoutConstraint activateConstraints:@[self.fixedInBottomConstraint, self.fixedInLeftConstraint, self.fixedInRightConstraint, self.fixedInTopConstraint]];

    
    [UIView animateWithDuration:0.25 animations:^{
        [self setNeedsUpdateConstraints];
    }];
                           
}

- (void) deactivatePositionConstraints {
    [NSLayoutConstraint deactivateConstraints:self.constraints];
    
    self.widthConstraint.active = YES;
    self.heightConstraint.active = YES;
}

-(void)notifyShapeDataChanged {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [[self shapeDelegate] fillColor];
        self.layer.borderColor = [[[self shapeDelegate] borderColor] CGColor];
        self.layer.cornerRadius = [[self shapeDelegate] cornerRadius];
        
        if (self.isFirstResponder) {
            self.layer.borderWidth = [[self shapeDelegate] borderWidth];
        }
    }];
}

- (void)translate:(CGPoint)translation layout:(BOOL)shouldLayout {
    if(!self.isSelected){
        return;
    }
    
    self.topConstraint.constant += translation.y;
    if (self.topConstraint.constant < 0){
        self.topConstraint.constant = 0;
    } else if(self.topConstraint.constant > self.superview.frame.size.height - self.frame.size.height){
        self.topConstraint.constant = self.superview.frame.size.height - self.frame.size.height;
    }
    
    self.leftConstraint.constant += translation.x;
    if(self.leftConstraint.constant < 0){
        self.leftConstraint.constant = 0;
    } else if(self.leftConstraint.constant > self.superview.frame.size.width - self.frame.size.width){
        self.leftConstraint.constant = self.superview.frame.size.width - self.frame.size.width;
    }
    
    if (shouldLayout) {
        [self setNeedsLayout];
    }
}

- (void) viewTapped: (UIGestureRecognizer*) sender {
    if (self.isSelected) {
        [self doDeslect];
    } else {
        [self doSelect];
    }
}

#pragma mark Selectable Utils

- (void)doSelect {
    self.isSelected = YES;
    self.layer.borderColor = [[[self shapeDelegate] borderColor] CGColor];
    self.layer.borderWidth = [[self shapeDelegate] borderWidth];
}

- (void)doDeslect {
    self.isSelected = NO;
    self.layer.borderColor = [[UIColor clearColor] CGColor];
    self.layer.borderWidth = 0;
}

@end
