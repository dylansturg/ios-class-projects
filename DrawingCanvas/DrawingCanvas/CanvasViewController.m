//
//  ViewController.m
//  DrawingCanvas
//
//  Created by Dylan Sturgeon on 4/21/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "CanvasViewController.h"
#import "SettingsKeysHelper.h"
#import "CanvasView.h"
#import "UIColor+Hex.h"

@interface CanvasViewController ()
@property (weak, nonatomic) IBOutlet CanvasView *canvas;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *canvasWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *canvasHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *canvasLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *canvasBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerXConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYConstraint;

@property(strong, nonatomic) UIPanGestureRecognizer *dragCanvasGesture;

@end

@implementation CanvasViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setttingsChanged) name:NSUserDefaultsDidChangeNotification object:nil];
    
    [self updateShapeSettings];
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    self.dragCanvasGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragged:)];
    self.dragCanvasGesture.minimumNumberOfTouches = 1;
    self.dragCanvasGesture.maximumNumberOfTouches = 1;
    
    
    [self.view addGestureRecognizer:self.dragCanvasGesture];
    CGFloat canvasDimension = 1.5 * MAX(self.view.frame.size.width, self.view.frame.size.height);
    self.canvasWidthConstraint.constant = canvasDimension;
    self.canvasHeightConstraint.constant = canvasDimension;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view setNeedsLayout];
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.centerXConstraint.active = NO;
    self.centerYConstraint.active = NO;
    self.centerXConstraint = nil;
    self.centerYConstraint = nil;
    
    self.canvasLeadingConstraint.constant = (self.view.frame.size.width - self.canvas.frame.size.width) / 2;
    self.canvasBottomConstraint.constant = (self.view.frame.size.height - self.canvas.frame.size.height) / 2;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view setNeedsLayout];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self adjustConstraintsToStayInFrameWithSize:size];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)dragged: (UIGestureRecognizer*) sender {
    assert(sender == self.dragCanvasGesture);
    
    CGPoint translation = [self.dragCanvasGesture translationInView:self.view];
    [self.dragCanvasGesture setTranslation:CGPointZero inView:self.view];
    
    self.canvasLeadingConstraint.constant += translation.x;
    self.canvasBottomConstraint.constant -= translation.y;
    
    [self adjustConstraintsToStayInFrameWithSize:self.view.frame.size];
}

- (void)adjustConstraintsToStayInFrameWithSize:(CGSize)size {
    
    if(self.canvasLeadingConstraint.constant > 0){
        self.canvasLeadingConstraint.constant = 0;
    } else if(self.canvasLeadingConstraint.constant < size.width - self.canvas.frame.size.width){
        self.canvasLeadingConstraint.constant = size.width - self.canvas.frame.size.width;
    }

    if(self.canvasBottomConstraint.constant > 0){
        self.canvasBottomConstraint.constant = 0;
    } else if(self.canvasBottomConstraint.constant < size.height - self.canvas.frame.size.height){
        self.canvasBottomConstraint.constant = size.height - self.canvas.frame.size.height;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view setNeedsLayout];
    }];
}

-(void)setttingsChanged {
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateShapeSettings];
}

-(void) updateShapeSettings {
    CGFloat cornerRadius = [[NSUserDefaults standardUserDefaults] floatForKey:[SettingsKeysHelper ShapeCornerRadius]];
    NSString *fillColorString = [[NSUserDefaults standardUserDefaults] stringForKey:[SettingsKeysHelper ShapeFillColor]];
    
    UIColor *fillColor = [UIColor colorFromHexString:fillColorString];
    
    if (self.canvas.shapeFillColor != fillColor) {
        self.canvas.shapeFillColor = fillColor;
    }
    if (self.canvas.shapeCornerRadius != cornerRadius) {
        self.canvas.shapeCornerRadius = cornerRadius;
    }
}

@end
