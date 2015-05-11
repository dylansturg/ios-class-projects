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
    
    self.deck.delegate = self.discardPile;
    self.discardPile.cardSource = self.deck;

    [self.deck shuffleDeck];
    
    self.discardPile.layer.cornerRadius = 5.0;
    self.discardPile.layer.borderColor = [[UIColor blackColor] CGColor];
    self.discardPile.layer.borderWidth = 2.0;
}


@end
