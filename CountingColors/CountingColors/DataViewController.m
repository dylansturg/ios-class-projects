//
//  DataViewController.m
//  CountingColors
//
//  Created by Dylan Sturgeon on 3/18/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
