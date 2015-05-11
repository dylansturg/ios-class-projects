//
//  DeckView.h
//  AccessibleCards
//
//  Created by Dylan Sturgeon on 5/11/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CardView.h"
#import "DiscardPileView.h"

@protocol DeckDelegate;

@interface DeckView : UIView <CardSource>

@property (weak, nonatomic) id<DeckDelegate> delegate;

- (void) setDeckCards: (NSArray*) cards;

@end

@protocol DeckDelegate <NSObject>

- (void) didShuffleDeck: (DeckView*) deckView;

@end
