//
//  DataViewController.m
//  CountingColors
//
//  Created by Dylan Sturgeon on 3/18/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "DataViewController.h"
#import "AppDelegate.h"
#import "Color.h"

#import <CoreData/CoreData.h>

@interface DataViewController ()
@property (weak, nonatomic) IBOutlet UILabel *redPressedLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenPressedLabel;
@property (weak, nonatomic) IBOutlet UILabel *bluePressedLabel;
@property (weak, nonatomic) IBOutlet UILabel *customPressedLabel;
@property (weak, nonatomic) IBOutlet UILabel *randomPressedLabel;

@end

@implementation DataViewController

- (instancetype)init {
    if (self =[super init]){
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Data" image:[UIImage imageNamed:@"Data"] selectedImage:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData:nil];
}

- (void)reloadData: (void (^)(void))completion {
    NSArray *colorNames = @[@"Red", @"Green", @"Blue", @"Custom", @"Random"];
    for (NSString* name in colorNames) {
        int pressedCount = [self fetchPressedCount:name];
        UILabel *label = [self valueForKey:[NSString stringWithFormat:@"%@PressedLabel", [name lowercaseString]]];
        if (label){
            label.text = [NSString stringWithFormat:@"%d", pressedCount];
        }
    }
    
    if (completion) {
        completion();
    }
}

- (IBAction)onReset:(id)sender {
    UIAlertController *resetSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Reset Counts", nil) message:NSLocalizedString(@"Reset all color pressed counts?", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    [resetSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Reset", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"User pressed reset");
        [self clearAllPressedCounts];
    }]];
    
    [resetSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    
    if (resetSheet.popoverPresentationController){
        resetSheet.popoverPresentationController.sourceView = sender;
        resetSheet.popoverPresentationController.sourceRect = ((UIButton*)sender).bounds;
    }
    [self presentViewController:resetSheet animated:YES completion:nil];
}

- (void)clearAllPressedCounts {
    NSManagedObjectContext *context = ((AppDelegate*) [[UIApplication sharedApplication] delegate]).managedObjectContext;
    NSFetchRequest *fetchAllColors = [NSFetchRequest fetchRequestWithEntityName:@"Color"];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchAllColors error:&error];
    
    if(error){
        NSLog(@"Error fetching all colors: %@", error);
    }
    
    if(results.count > 0){
        for (Color* color in results) {
            color.pressedCount = [NSNumber numberWithInt:0];
        }
        [context save:&error];
        if (error) {
            NSLog(@"Error saving updated colors: %@", error);
        }
    }
    [self reloadData:nil];
}

- (int) fetchPressedCount: (NSString*) colorNamed{
    NSManagedObjectContext *context = ((AppDelegate*) [[UIApplication sharedApplication] delegate]).managedObjectContext;
    NSFetchRequest *fetchColor = [[NSFetchRequest alloc]initWithEntityName:@"Color"];
    fetchColor.predicate = [NSPredicate predicateWithFormat:@"name == %@", colorNamed];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchColor error:&error];
    
    if (error) {
        NSLog(@"Error fetching Colors from CoreData: %@", error);
    }
    
    if (results.count > 0){
        return (int) ((Color*) results[0]).pressedCount.integerValue;
    }
    
    return 0;
}



@end
