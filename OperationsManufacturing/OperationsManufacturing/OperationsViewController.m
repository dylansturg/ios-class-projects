//
//  ViewController.m
//  OperationsManufacturing
//
//  Created by Dylan Sturgeon on 5/16/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "OperationsViewController.h"
#import "OperationView.h"

@interface OperationsViewController ()
@property (weak, nonatomic) IBOutlet OperationView *gizmoOperationView;
@property (weak, nonatomic) IBOutlet OperationView *widgetOperationView;
@property (weak, nonatomic) IBOutlet OperationView *gadgetsOperationView;
@property (weak, nonatomic) IBOutlet OperationView *multitoolsOperationView;

@end

@implementation OperationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gizmoOperationView.productName = @"Gizmos";
    self.widgetOperationView.productName = @"Widgets";
    self.gadgetsOperationView.productName = @"Gadgets";
    self.multitoolsOperationView.productName = @"Multitools";
}


@end
