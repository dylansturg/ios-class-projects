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
    
    NSArray *colorNames = @[@"Red", @"Green", @"Blue", @"Custom", @"Random"];
    for (NSString* name in colorNames) {
        int pressedCount = [self fetchPressedCount:name];
        UILabel *label = [self valueForKey:[NSString stringWithFormat:@"%@PressedLabel", [name lowercaseString]]];
        if (label){
            label.text = [NSString stringWithFormat:@"%d", pressedCount];
        }
    }
}

- (IBAction)onReset:(id)sender {

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
