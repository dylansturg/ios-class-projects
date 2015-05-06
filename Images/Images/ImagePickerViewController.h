//
//  ImagePickerViewController.h
//  Images
//
//  Created by Dylan Sturgeon on 5/6/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImagePickerDelegate;

@interface ImagePickerViewController : UITableViewController

@property (weak, nonatomic) id<ImagePickerDelegate> delegate;

@end

// info dict key(s)
extern NSString *const ImagePickerControllerInfoImage;

@protocol ImagePickerDelegate <NSObject>

typedef NS_ENUM(NSInteger, ImagePickerViewControllerCancelReason){
    ImagePickerViewControllerCancelReasonUserRequested,
    ImagePickerViewControllerCancelReasonUnauthorized,
};

- (void)imagePicker:(ImagePickerViewController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerDidCancel:(ImagePickerViewController *)picker withReason:(ImagePickerViewControllerCancelReason)reason;

@end
