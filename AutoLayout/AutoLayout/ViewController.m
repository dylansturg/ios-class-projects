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
@property (weak, nonatomic) IBOutlet UIView *boxContainer;
@property (weak, nonatomic) IBOutlet UISlider *slider;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redBottomToContainerBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redTopToContainerTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redTrailingToContainerTrailing;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueTopToRedBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueTopToContainerTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueLeadingToContainerLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueBottomToContainerBottom;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *proportionalHeight;
@property (strong, nonatomic) NSLayoutConstraint *proportionalWidth;

@property (strong, nonatomic) NSArray *landscapeConstraints;
@property (strong, nonatomic) NSArray *portraitConstraints;

@property (nonatomic) CGFloat totalHeight;

@end

// NSLayoutConstraint seems to lose its mind with a 0 multiplier.
// I'm not a big fan of infinity either, I guess.  Calculus...
CGFloat MinimumMultiplier = 0.0001;

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.portraitConstraints = @[self.redBottomToContainerBottom, self.redTrailingToContainerTrailing, self.blueLeadingToContainerLeading, self.blueTopToContainerTop, self.blueTopToRedBottom];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    
    CGFloat multiplier = MAX(self.slider.value, MinimumMultiplier);
    if ([self sizeIsLandscape:size]) {
        self.proportionalHeight.active = NO;
        
        if (self.proportionalWidth == nil){

            self.proportionalWidth = [NSLayoutConstraint constraintWithItem:self.proportionalHeight.firstItem attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.proportionalHeight.secondItem attribute:NSLayoutAttributeWidth multiplier:multiplier constant:self.proportionalHeight.constant];
            
            self.proportionalWidth.priority = self.proportionalHeight.priority;
            
            NSLayoutConstraint *redTop = [NSLayoutConstraint constraintWithItem:self.redBox attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.boxContainer attribute:NSLayoutAttributeTop multiplier:1 constant:0];
            NSLayoutConstraint *blueTop = [NSLayoutConstraint constraintWithItem:self.blueBox attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.boxContainer attribute:NSLayoutAttributeTop multiplier:1 constant:0];
            
            NSLayoutConstraint *redBottom = [NSLayoutConstraint constraintWithItem:self.redBox attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.boxContainer attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
            NSLayoutConstraint *blueBottom = [NSLayoutConstraint constraintWithItem:self.blueBox attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.boxContainer attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
            
            NSLayoutConstraint *horzSpace = [NSLayoutConstraint constraintWithItem:self.redBox attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.blueBox attribute:NSLayoutAttributeLeft multiplier:1 constant:-8];

            self.landscapeConstraints = @[redTop, blueTop, redBottom, blueBottom, horzSpace];
        } else {
            self.proportionalWidth = [self duplicateConstraint:self.proportionalWidth withMultiplier:multiplier];
        }
        
        [NSLayoutConstraint deactivateConstraints:self.portraitConstraints];
        
        self.proportionalWidth.active = YES;
        [NSLayoutConstraint activateConstraints:self.landscapeConstraints];
        
    } else {
        self.proportionalWidth.active = NO;
        
        [NSLayoutConstraint deactivateConstraints:self.landscapeConstraints];
        
        self.proportionalHeight = [self duplicateConstraint:self.proportionalHeight withMultiplier:multiplier];
        self.proportionalHeight.active = YES;
        [NSLayoutConstraint activateConstraints:self.portraitConstraints];
    }
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self updateViewConstraints];
    } completion:nil];
}

- (NSUInteger)supportedInterfaceOrientations{
    // I think it's silly that I have a checkbox for this option and whatever I put in that checkbox isn't the default...
    // #thanksapple #justmyopinion
    return UIInterfaceOrientationMaskAll;
}

- (BOOL) sizeIsLandscape:(CGSize)size{
    return size.width > size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderChanged:(UISlider *)sender {
    CGFloat val = sender.value;
    
    CGFloat multiplier = MAX(val, MinimumMultiplier);
    
    if (self.proportionalHeight.active) {
        self.proportionalHeight.active = NO;
        NSLayoutConstraint *propHeight = [self duplicateConstraint:self.proportionalHeight withMultiplier:multiplier];
        
        propHeight.active = YES;
        self.proportionalHeight = nil;
        self.proportionalHeight = propHeight;
    } else if (self.proportionalWidth.active){
        self.proportionalWidth.active = NO;
        
        NSLayoutConstraint *propWidth = [self duplicateConstraint:self.proportionalWidth withMultiplier:multiplier];
        propWidth.active = YES;
        
        self.proportionalWidth = nil;
        self.proportionalWidth = propWidth;
    } else {
        // Well, this probably shouldn't happen
        assert(self.proportionalWidth.active || self.proportionalHeight.active);
    }
    
    [self updateViewConstraints];
}

- (CGFloat) scaleSliderToConstraint: (CGFloat)value{
    return 0;
}

- (NSLayoutConstraint*) duplicateConstraint:(NSLayoutConstraint*) constraint withMultiplier:(CGFloat)multiplier {
    NSLayoutConstraint *updatedConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:constraint.secondItem attribute:constraint.secondAttribute multiplier:multiplier constant:constraint.constant];
    updatedConstraint.priority = constraint.priority;
    return updatedConstraint;
}

@end
