//
//  ImagePickerCollectionViewController.h
//  Images
//
//  Created by Dylan Sturgeon on 5/6/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

@interface ImagePickerCollectionViewController : UICollectionViewController
@property (weak, nonatomic) id<ImagePickerDelegate> delegate;
@property (weak, nonatomic) ImagePickerViewController *container;
@property (strong, nonatomic) PHAssetCollection *album;
@end
