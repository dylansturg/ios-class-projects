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
@property (weak, nonatomic) IBOutlet UILabel *sessionCountLabel;
@end

@implementation ColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self presentedColorName]){
        int sessionPressedCount = [self fetchColorCount:[self presentedColorName] session: YES];
        self.sessionCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"SessionPressedFormat", nil), sessionPressedCount];
    }
    
    if([self presentedColor]){
        self.view.backgroundColor = [self presentedColor];
    }
}

- (int) fetchColorCount: (NSString*) colorName session:(BOOL)getSession {
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
        Color *color = (Color*)results[0];
        int value = getSession ? color.sessionPressedCount.intValue : color.pressedCount.intValue;
        return value;
    }
}

- (IBAction)onDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
