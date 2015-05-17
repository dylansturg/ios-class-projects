//
//  ProductOperation.h
//  OperationsManufacturing
//
//  Created by Dylan Sturgeon on 5/16/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Completion)(void);

@interface ProductOperation : NSOperation

+ (instancetype) productOperationWithCompletionBlock: (Completion) block;

@end
