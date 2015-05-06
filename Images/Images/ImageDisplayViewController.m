//
//  ViewController.m
//  Images
//
//  Created by Dylan Sturgeon on 5/6/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "ImageDisplayViewController.h"

@interface ImageDisplayViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIPopoverController *pickerPopover;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *standardPickerButton;
@property (weak, nonatomic) IBOutlet UIButton *customPickerButton;

@end

@implementation ImageDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark InterfaceBuilder

- (IBAction)showStandardPicker:(id)sender {
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIAlertController *notAvailableAlert =  [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Image Picker Not Available", nil) message:NSLocalizedString(@"We are unable to display an image picker because your device does not support the appropriate image source type.  Please consider buying a new device.  Or several.", nil) preferredStyle:UIAlertControllerStyleAlert];
        [notAvailableAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Take Me to the Apple Store!", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSURL *url = [NSURL URLWithString:@"http://store.apple.com/"];
            [[UIApplication sharedApplication] openURL:url];
        }]];
        [notAvailableAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"No Thanks", nil) style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:notAvailableAlert animated:YES completion:nil];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    picker.delegate = self;
    
    // Docs say that the UIImagePickerController needs to be presented in a popover on iPad
    // if using sourceType isn't camera but it seems to work fine and looks better if I don't...
    // Guess we will see...
    // Leaving the code to accomplish it with popover for reference
//    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ) {
//        // It seems to work fine if I don't do this, but Apple docs said it would crash if you use
//        // sourceType = ...PhotoLibrary and don't present in a popover...
//        self.pickerPopover = [[UIPopoverController alloc] initWithContentViewController:picker];
//        [self.pickerPopover presentPopoverFromRect:self.standardPickerButton.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        
//    } else {
        [self presentViewController:picker animated:YES completion:nil];
//    }
    
}

- (IBAction)showCustomPicker:(id)sender {
}


#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
