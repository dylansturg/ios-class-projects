//
//  ImagePickerTableViewCell.h
//  Images
//
//  Created by Dylan Sturgeon on 5/6/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePickerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
