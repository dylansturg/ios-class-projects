//
//  ViewController.m
//  AccessibleCards
//
//  Created by Dylan Sturgeon on 5/11/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "CardDealerViewController.h"
#import "DiscardPileView.h"
#import "DeckView.h"

@interface CardDealerViewController ()
@property (weak, nonatomic) IBOutlet DeckView *deck;
@property (weak, nonatomic) IBOutlet DiscardPileView *discardPile;

@end

@implementation CardDealerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
