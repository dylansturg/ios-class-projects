//
//  ColorsViewController.m
//  CountingColors
//
//  Created by Dylan Sturgeon on 3/18/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "ColorsViewController.h"
#import "ColorViewController.h"

@interface ColorsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *redTextField;
@property (strong, nonatomic) IBOutlet UIView *greenTextField;
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
    [self presentColorViewController:nil];
}
- (IBAction)greenClicked:(UIButton *)sender {
    [self presentColorViewController:nil];
}
- (IBAction)blueClicked:(UIButton *)sender {
    [self presentColorViewController:nil];
}
- (IBAction)customClicked:(UIButton *)sender {
    [self presentColorViewController:nil];
}
- (IBAction)randomClicked:(UIButton *)sender {
    [self presentColorViewController:nil];
}

- (void) presentColorViewController: (UIColor *) color{
    ColorViewController *colorVC = [[ColorViewController alloc] init];
    
    [self presentViewController:colorVC animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
