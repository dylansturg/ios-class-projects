//
//  DiscardPileView.m
//  AccessibleCards
//
//  Created by Dylan Sturgeon on 5/11/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "DiscardPileView.h"

@interface DiscardPileView ()
@property (strong, nonatomic) CardView *topCard;
@end

@implementation DiscardPileView

- (void)awakeFromNib {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tapGesture];
}

# pragma mark UIAccessibility

- (BOOL)isAccessibilityElement {
    return YES;
}

- (NSString *)accessibilityLabel {
    if (self.topCard){
        return self.topCard.accessibilityLabel;
    } else {
        return NSLocalizedString(@"Discard pile", @"accessibility label for DiscardPileView");
    }
}

- (NSString *)accessibilityHint {
    return NSLocalizedString(@"Flips a card", @"accessibility hint for DiscardPileView");
}

# pragma mark DeckDelegate

- (void)didShuffleDeck:(DeckView *)deckView {
    if (self.topCard) {
        [self.topCard removeFromSuperview];
        self.topCard = nil;
    }
}

# pragma mark Private
- (void) tapped: (id) sender {
    if (self.topCard){
        [self.topCard removeFromSuperview];
    }
    
    CardView *nextCard = [self.cardSource drawNextCard:self];
    if (nextCard) {
        self.topCard = nextCard;
        [self addSubview:self.topCard];
    }
}

@end
