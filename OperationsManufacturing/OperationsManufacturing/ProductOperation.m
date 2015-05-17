//
//  ProductOperation.m
//  OperationsManufacturing
//
//  Created by Dylan Sturgeon on 5/16/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "ProductOperation.h"

@implementation ProductOperation

+ (instancetype)productOperationWithCompletionBlock:(Completion)block {
    ProductOperation *productOp = [[ProductOperation alloc] init];
    productOp.completionBlock = block;
    
    return productOp;
}

- (void)main {
    int sleepTime = USEC_PER_SEC * arc4random_uniform(3) + arc4random_uniform(USEC_PER_SEC) + USEC_PER_SEC / 2;
    usleep(sleepTime);
}

@end
