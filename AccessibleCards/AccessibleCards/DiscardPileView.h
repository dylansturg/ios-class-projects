//
//  DiscardPileView.h
//  AccessibleCards
//
//  Created by Dylan Sturgeon on 5/11/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CardView.h"
#import "CardDealerViewController.h"

@interface DiscardPileView : UIView <DeckDelegate>

@property (weak, nonatomic) id<CardSource> cardSource;

@end
