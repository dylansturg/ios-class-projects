//
//  OperationView.m
//  OperationsManufacturing
//
//  Created by Dylan Sturgeon on 5/16/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "OperationView.h"

@interface OperationView ()

@property (nonatomic, weak) UILabel *operationLabel;
@property (nonatomic, weak) UILabel *processingCountLabel;
@property (nonatomic, weak) UILabel *parallelOperationsCountLabel;

@property (nonatomic, strong) NSOperationQueue *productQueue;
@property (nonatomic, assign) NSInteger productionCount;

@end

@implementation OperationView

- (void)awakeFromNib {
    [self OperationView_commonInterfaceInit];
    [self OperationView_commonWorkInit];
}

# pragma mark Private
- (void)setProductName:(NSString *)productName {
    _productName = [productName copy];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.operationLabel.text = [self productName];
    }];
}

- (void)setProductionCount:(NSInteger)productionCount {
    _productionCount = productionCount;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.processingCountLabel.text = [NSString stringWithFormat:@"%ld", (long)productionCount];
    }];
}

- (void) queueOneOperation: (id) sender {
    [self queueOperations:1];
}

- (void) queueFiveOperations: (id) sender {
    [self queueOperations:5];
}

- (void) queueTenOperations: (id) sender {
    [self queueOperations:10];
}

- (void) queueOperations: (NSInteger) count {
    
    @synchronized(self){
        self.productionCount += count;
    }
    
    for (int i=0; i < count; i++){
        [self.productQueue addOperationWithBlock:^{
            int sleepTime = USEC_PER_SEC * arc4random_uniform(3) + arc4random_uniform(USEC_PER_SEC) + USEC_PER_SEC / 2;
            usleep(sleepTime);
            
            @synchronized(self){
                if (self.productionCount > 0) {
                    self.productionCount--;
                }
            }
        }];
    }
}

- (void) incrementParallelCount: (id) sender {
    self.productQueue.maxConcurrentOperationCount = self.productQueue.maxConcurrentOperationCount + 1;
    [self updateParallelCountLabel];
}

- (void) decrementParallelCount: (id) sender {
    if (self.productQueue.maxConcurrentOperationCount > 0){
        self.productQueue.maxConcurrentOperationCount = self.productQueue.maxConcurrentOperationCount - 1;
    }
    [self updateParallelCountLabel];
}

- (void) updateParallelCountLabel {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.parallelOperationsCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.productQueue.maxConcurrentOperationCount];
    }];
}

- (void) OperationView_commonWorkInit {
    self.productQueue = [[NSOperationQueue alloc] init];
    self.productQueue.maxConcurrentOperationCount = 0;
    self.productionCount = 0;
}

- (void) OperationView_commonInterfaceInit {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UILabel *opLabel = [[UILabel alloc] init];
    [opLabel setText:self.productName ? self.productName : NSLocalizedString(@"Operation", @"Default operation label")];
    self.operationLabel = opLabel;
    [self.operationLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.operationLabel];
    opLabel = nil;
    
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.operationLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.operationLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTopMargin multiplier:1 constant:0]];
    
    UILabel *countLabel = [[UILabel alloc] init];
    [countLabel setText:@"0"];
    self.processingCountLabel = countLabel;
    [self.processingCountLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.processingCountLabel];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.processingCountLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailingMargin multiplier:1 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.processingCountLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.operationLabel attribute:NSLayoutAttributeBottomMargin multiplier:1 constant:20]];
    
    UILabel *processingCountTitleLabel = [[UILabel alloc] init];
    [processingCountTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [processingCountTitleLabel setText:NSLocalizedString(@"In Progress:", @"Number of operations in progress label")];
    [self addSubview:processingCountTitleLabel];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:processingCountTitleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeadingMargin multiplier:1 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:processingCountTitleLabel attribute:NSLayoutAttributeCenterYWithinMargins relatedBy:NSLayoutRelationEqual toItem:self.processingCountLabel attribute:NSLayoutAttributeCenterYWithinMargins multiplier:1 constant:0]];
    
    UIButton *addTen = [UIButton buttonWithType:UIButtonTypeSystem];
    [addTen setTranslatesAutoresizingMaskIntoConstraints:NO];
    [addTen addTarget:self action:@selector(queueTenOperations:) forControlEvents:UIControlEventTouchUpInside];
    [addTen setTitle:@"+10" forState:UIControlStateNormal];
    [self addSubview:addTen];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:addTen attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailingMargin multiplier:1 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:addTen attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.processingCountLabel attribute:NSLayoutAttributeBottomMargin multiplier:1 constant:0]];
    
    UIButton *addFive = [UIButton buttonWithType:UIButtonTypeSystem];
    [addFive setTranslatesAutoresizingMaskIntoConstraints:NO];
    [addFive addTarget:self action:@selector(queueFiveOperations:) forControlEvents:UIControlEventTouchUpInside];
    [addFive setTitle:@"+5" forState:UIControlStateNormal];
    [self addSubview:addFive];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:addFive attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:addTen attribute:NSLayoutAttributeLeadingMargin multiplier:1 constant:-10]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:addFive attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.processingCountLabel attribute:NSLayoutAttributeBottomMargin multiplier:1 constant:0]];
    
    
    UIButton *addOne = [UIButton buttonWithType:UIButtonTypeSystem];
    [addOne setTranslatesAutoresizingMaskIntoConstraints:NO];
    [addOne addTarget:self action:@selector(queueOneOperation:) forControlEvents:UIControlEventTouchUpInside];
    [addOne setTitle:@"+1" forState:UIControlStateNormal];
    [self addSubview:addOne];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:addOne attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:addFive attribute:NSLayoutAttributeLeadingMargin multiplier:1 constant:-10]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:addOne attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.processingCountLabel attribute:NSLayoutAttributeBottomMargin multiplier:1 constant:0]];
    
    
    UILabel *parallelOpsLabel = [[UILabel alloc] init];
    [parallelOpsLabel setText:NSLocalizedString(@"Parallel:", @"Label for parallel counter")];
    [parallelOpsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:parallelOpsLabel];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:parallelOpsLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeadingMargin multiplier:1 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:parallelOpsLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:addTen attribute:NSLayoutAttributeBottomMargin multiplier:1 constant:20]];
    
    UIButton *incrementParallelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    incrementParallelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [incrementParallelBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [incrementParallelBtn addTarget:self action:@selector(incrementParallelCount:) forControlEvents:UIControlEventTouchUpInside];
    [incrementParallelBtn setTitle:@"+" forState:UIControlStateNormal];
    [self addSubview:incrementParallelBtn];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:incrementParallelBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailingMargin multiplier:1 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:incrementParallelBtn attribute:NSLayoutAttributeCenterYWithinMargins relatedBy:NSLayoutRelationEqual toItem:parallelOpsLabel attribute:NSLayoutAttributeCenterYWithinMargins multiplier:1 constant:0]];
    
    UILabel *parallelOpsCountLabel = [[UILabel alloc] init];
    self.parallelOperationsCountLabel = parallelOpsCountLabel;
    [self.parallelOperationsCountLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.parallelOperationsCountLabel setText:@"0"];
    [self addSubview:self.parallelOperationsCountLabel];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.parallelOperationsCountLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:incrementParallelBtn attribute:NSLayoutAttributeLeadingMargin multiplier:1 constant:-5]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.parallelOperationsCountLabel attribute:NSLayoutAttributeCenterYWithinMargins relatedBy:NSLayoutRelationEqual toItem:parallelOpsLabel attribute:NSLayoutAttributeCenterYWithinMargins multiplier:1 constant:0]];
    
    UIButton *decrementParallelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [decrementParallelBtn addTarget:self action:@selector(decrementParallelCount:) forControlEvents:UIControlEventTouchUpInside];
    decrementParallelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [decrementParallelBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [decrementParallelBtn setTitle:@"-" forState:UIControlStateNormal];
    [self addSubview:decrementParallelBtn];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:decrementParallelBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.parallelOperationsCountLabel attribute:NSLayoutAttributeLeadingMargin multiplier:1 constant:-5]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:decrementParallelBtn attribute:NSLayoutAttributeCenterYWithinMargins relatedBy:NSLayoutRelationEqual toItem:parallelOpsLabel attribute:NSLayoutAttributeCenterYWithinMargins multiplier:1 constant:0]];
    
    
    [NSLayoutConstraint activateConstraints:constraints];
}

@end
