//
//  ViewController.h
//  AccessibleCards
//
//  Created by Dylan Sturgeon on 5/11/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeckView;
@class DiscardPileView;
@class CardView;

@protocol DeckDelegate <NSObject>
- (void) didShuffleDeck: (DeckView*) deckView;
@end

@protocol CardSource <NSObject>
- (CardView*) drawNextCard: (DiscardPileView*) discardPileView;
@end

@interface CardDealerViewController : UIViewController

@end

