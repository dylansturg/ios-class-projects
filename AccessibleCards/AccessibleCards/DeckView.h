//
//  DeckView.h
//  AccessibleCards
//
//  Created by Dylan Sturgeon on 5/11/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CardView.h"

@protocol DeckDelegate;

@interface DeckView : UIView

@property (weak, nonatomic) id<DeckDelegate> delegate;

@end

@protocol DekcDelegate <NSObject>

- (void) didShuffleDeck: (DeckView*) deckView;

@end