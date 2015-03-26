//
//  ViewController.m
//  AutoLayout
//
//  Created by Dylan Sturgeon on 3/22/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *blueBox;
@property (weak, nonatomic) IBOutlet UIView *redBox;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redBottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueBottomSpace;

@property (nonatomic) CGFloat totalHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.totalHeight = self.redBox.frame.size.height;
    
    CGFloat redConstant = (self.totalHeight * 0.5) + 8 + 4;
    CGFloat blueConstant = (self.totalHeight * 0.5) + 4;
    
    self.blueTopSpace.constant = blueConstant;
    self.redBottomSpace.constant = redConstant;

    [self updateViewConstraints];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderChanged:(UISlider *)sender {
    float val = sender.value;
    if (val == 1) {
        CGFloat expected = self.view.frame.size.width;
    }
    NSLog(@"Changing constraint to value: %f", val);
    
    CGFloat redMultiplier = sender.value;
    CGFloat blueMultiplier = 1 - sender.value;
    
    CGFloat redConstant = (self.totalHeight * redMultiplier) + 8 + 4;
    CGFloat blueConstant = (self.totalHeight * blueMultiplier) + 4;
    
    self.blueTopSpace.constant = MIN(blueConstant, self.totalHeight);
    self.redBottomSpace.constant = MIN(redConstant, self.totalHeight+8);
    
    
    [self updateViewConstraints];
}

- (NSLayoutConstraint*) duplicateConstraint:(NSLayoutConstraint*) constraint withMultiplier:(CGFloat)multiplier {
    multiplier = MAX(multiplier, 0.01);
    NSLayoutConstraint *updatedConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:constraint.secondItem attribute:constraint.secondAttribute multiplier:multiplier constant:constraint.constant];
    return updatedConstraint;
}

@end
