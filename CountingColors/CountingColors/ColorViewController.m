//
//  ColorViewController.m
//  CountingColors
//
//  Created by Dylan Sturgeon on 3/18/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "ColorViewController.h"
#import "Color.h"
#import "AppDelegate.h"

#import <CoreData/CoreData.h>

@interface ColorViewController ()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@end

@implementation ColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self presentedColorName]){
        int presentedCount = [self fetchColorCount:[self presentedColorName]];
        self.countLabel.text = [NSString stringWithFormat:@"Pressed %d Times", presentedCount];
    }
    
    if([self presentedColor]){
        self.view.backgroundColor = [self presentedColor];
    }
}

- (int) fetchColorCount: (NSString*) colorName {
    NSManagedObjectContext *context = ((AppDelegate*) [[UIApplication sharedApplication] delegate]).managedObjectContext;
    NSFetchRequest *fetchColors = [[NSFetchRequest alloc] initWithEntityName:@"Color"];
    fetchColors.predicate = [NSPredicate predicateWithFormat:@"name == %@", colorName];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchColors error:&error];
    
    if (error) {
        NSLog(@"Error fetching Colors from CoreData: %@", error);
    }
    
    if (results.count <= 0){
        // error
        return 0;
    } else {
        return (int) ((Color*)results[0]).pressedCount.integerValue;
    }
}

- (IBAction)onDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
