//
//  ColorsViewController.m
//  CountingColors
//
//  Created by Dylan Sturgeon on 3/18/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "ColorsViewController.h"
#import "ColorViewController.h"
#import "Color.h"
#import "AppDelegate.h"
#import "UIColor+Extensions.h"

#import <CoreData/CoreData.h>

@interface ColorsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *redTextField;
@property (weak, nonatomic) IBOutlet UITextField *greenTextField;

@property (weak, nonatomic) IBOutlet UITextField *blueTextField;

@end

@implementation ColorsViewController

- (instancetype)init {
    if (self =[super init]){
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Colors" image:[UIImage imageNamed:@"Colors"] selectedImage:nil];
    }
    return self;
}


- (IBAction)redClicked:(UIButton *)sender {
    [self logColorPress:@"Red"];
    [self presentColorViewController:[UIColor redColor] named:@"Red"];
}

- (IBAction)greenClicked:(UIButton *)sender {
    [self logColorPress:@"Green"];
    [self presentColorViewController:[UIColor greenColor] named:@"Green"];
}

- (IBAction)blueClicked:(UIButton *)sender {
    [self logColorPress:@"Blue"];
    [self presentColorViewController:[UIColor blueColor] named:@"Blue"];
}

- (IBAction)customClicked:(UIButton *)sender {
    [self logColorPress:@"Custom"];
    
    double colorRed = self.redTextField.text.doubleValue;
    double colorGreen = self.greenTextField.text.doubleValue;
    double colorBlue = self.blueTextField.text.doubleValue;
    
    UIColor *customColor = [UIColor colorWithRed:colorRed green:colorGreen blue:colorBlue alpha:1.0];
    [self presentColorViewController:customColor named:@"Custom"];
}

- (IBAction)randomClicked:(UIButton *)sender {
    [self logColorPress:@"Random"];
    [self presentColorViewController:[UIColor randomRGBColor] named:@"Random"];
}

- (void) logColorPress: (NSString *) colorName{
    NSManagedObjectContext *context = ((AppDelegate*) [[UIApplication sharedApplication] delegate]).managedObjectContext;
    NSFetchRequest *fetchColors = [[NSFetchRequest alloc] initWithEntityName:@"Color"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", colorName];
    fetchColors.predicate = predicate;

    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchColors error:&error];
    
    if (error) {
        NSLog(@"Failed to load Colors: %@", error);
    }
    
    if (results.count > 0){
        for (id colorResult in results) {
            Color *color = (Color*) colorResult;
            color.pressedCount = [NSNumber numberWithInt: color.pressedCount.intValue + 1];
        }
    } else {
        Color *newColor = [NSEntityDescription insertNewObjectForEntityForName:@"Color" inManagedObjectContext:context];
        newColor.name = [colorName copy];
        newColor.pressedCount = [NSNumber numberWithInt:1];
    }
    
    [context save:&error];
    
    if (error){
        NSLog(@"Failed to save changes %@", error);
    }
}

- (void) presentColorViewController: (UIColor *) color named:(NSString*) named{
    ColorViewController *colorVC = [[ColorViewController alloc] init];
    colorVC.presentedColor = color;
    colorVC.presentedColorName = named;
    
    [self presentViewController:colorVC animated:YES completion:nil];
}

@end
