//
//  ImagePickerNavigationController.h
//  Images
//
//  Created by Dylan Sturgeon on 5/6/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePickerViewController.h"

@interface ImagePickerNavigationController : UINavigationController
@property (weak, nonatomic) id<ImagePickerDelegate> imagePickerDelegate;
@end
