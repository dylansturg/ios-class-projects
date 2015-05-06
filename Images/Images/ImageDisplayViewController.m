//
//  ViewController.m
//  Images
//
//  Created by Dylan Sturgeon on 5/6/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "ImageDisplayViewController.h"
#import "ImagePickerNavigationController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ImageDisplayViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, ImagePickerDelegate>

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

#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ImagePickerNavigationController *pickerVC = [segue destinationViewController];
    pickerVC.imagePickerDelegate = self;
}

#pragma mark ImagePickerDelegate

- (void)imagePicker:(ImagePickerViewController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *pickedImage = info[ImagePickerControllerInfoImage];
    if (pickedImage){
        self.imageView.image = pickedImage;
    }
}

- (void)imagePickerDidCancel:(ImagePickerViewController *)picker withReason:(ImagePickerViewControllerCancelReason)reason {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (reason == ImagePickerViewControllerCancelReasonUnauthorized) {
        UIAlertController *notAvailableAlert =  [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Image Access Unauthorized", nil) message:NSLocalizedString(@"We can't show you any images if you don't give us permission.  We're sad now.  :(", nil) preferredStyle:UIAlertControllerStyleAlert];
        [notAvailableAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Too Bad!", nil) style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:notAvailableAlert animated:YES completion:nil];
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    BOOL error = YES;
    
    if (UTTypeConformsTo((__bridge CFStringRef)mediaType, kUTTypeImage)) {
        
        id originalImage = info[UIImagePickerControllerOriginalImage];
        id editedImage = info[UIImagePickerControllerEditedImage];
        
        if (editedImage){
            self.imageView.image = editedImage;
            error = NO;
        } else if(originalImage){
            self.imageView.image = originalImage;
            error = NO;
        } else {
            // No image selected?
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (error){
        UIAlertController *notAvailableAlert =  [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Unsuported Media Selected", nil) message:NSLocalizedString(@"The media you selected is not supported by this viewer.", nil) preferredStyle:UIAlertControllerStyleAlert];
        [notAvailableAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:notAvailableAlert animated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
