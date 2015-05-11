//
//  CardView.m
//  HWAccessibleCards
//
//  Created by Tim Ekl on 2/7/15.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "CardView.h"

@interface CardView ()

@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *suitLabel;

@end

@implementation CardView

+ (NSArray *)shuffledDeck;
{
    NSMutableArray *sortedCards = [NSMutableArray arrayWithCapacity:52];
    for (CardSuit suit = CardSuitClubs; suit <= CardSuitSpades; suit++) {
        for (CardRank rank = CardRankAce; rank <= CardRankKing; rank++) {
            [sortedCards addObject:[[CardView alloc] initWithRank:rank suit:suit]];
        }
    }
    
    // Do the shuffle (Fisher-Yates, that is)
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[sortedCards count]];
    for (NSUInteger i = 0; i < [sortedCards count]; i++) {
        NSUInteger j = arc4random_uniform((uint32_t)i);
        if (j != i) {
            result[i] = result[j];
        }
        result[j] = sortedCards[i];
    }
    
    return result;
}

#pragma mark - API

- (id)initWithRank:(CardRank)rank suit:(CardSuit)suit;
{
    // Pick some arbitrary non-zero-size frame
    if (!(self = [super initWithFrame:CGRectMake(0, 0, 50, 100)])) {
        return nil;
    }
    
    _rankLabel = [[UILabel alloc] init];
    _suitLabel = [[UILabel alloc] init];
    
    for (UILabel *label in @[ _rankLabel, _suitLabel ]) {
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_rankLabel, _suitLabel);
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_rankLabel]-|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:views]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_suitLabel]-|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:views]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_rankLabel]-[_suitLabel]-|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:views]];
    [NSLayoutConstraint constraintWithItem:_rankLabel
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_suitLabel
                                 attribute:NSLayoutAttributeHeight
                                multiplier:1.0
                                  constant:0.0].active = YES;
    
    // Use setters here so the labels are updated
    self.rank = rank;
    self.suit = suit;
    
    return self;
}

# pragma mark UIAccessibility

- (NSString *)accessibilityLabel {
    
    NSString *rankText;
    
    switch (self.rank) {
        case CardRankJack:
            rankText = NSLocalizedString(@"Jack", @"name for Jack rank");
            break;
        case CardRankQueen:
            rankText = NSLocalizedString(@"Queen", @"name for Queen rank");
            break;
        case CardRankKing:
            rankText = NSLocalizedString(@"King", @"name for King rank");
            break;
        case CardRankAce:
            rankText = NSLocalizedString(@"Ace", @"name for Ace rank");
            break;
        case CardRankTen:
            rankText = NSLocalizedString(@"Ten", nil);
            break;
        case CardRankNine:
            rankText = NSLocalizedString(@"Nine", nil);
            break;
        case CardRankEight:
            rankText = NSLocalizedString(@"Eight", nil);
            break;
        case CardRankSeven:
            rankText = NSLocalizedString(@"Seven", nil);
            break;
        case CardRankSix:
            rankText = NSLocalizedString(@"Six", nil);
            break;
        case CardRankFive:
            rankText = NSLocalizedString(@"Five", nil);
            break;
        case CardRankFour:
            rankText = NSLocalizedString(@"Four", nil);
            break;
        case CardRankThree:
            rankText = NSLocalizedString(@"Three", nil);
            break;
        case CardRankTwo:
            rankText = NSLocalizedString(@"Two", nil);
            break;
            
        default:
            break;
    }
    
    NSAssert(rankText != nil, @"Need a long-text version of this card's rank");
    
    return [NSString stringWithFormat:NSLocalizedString(@"%@ of %@", @"format string for CardView accessibility label"), NSLocalizedString(rankText, nil), NSLocalizedString(self.suitLabel.text, nil)];
}

#pragma mark Custom accessors

- (void)setRank:(CardRank)rank;
{
    _rank = rank;
    
    switch (rank) {
        case CardRankJack: self.rankLabel.text = @"J"; break;
        case CardRankQueen: self.rankLabel.text = @"Q"; break;
        case CardRankKing: self.rankLabel.text = @"K"; break;
        case CardRankAce: self.rankLabel.text = @"A"; break;
        default: self.rankLabel.text = [@(rank + 1) stringValue]; break;
    }
}

- (void)setSuit:(CardSuit)suit;
{
    _suit = suit;
    
    switch (suit) {
        case CardSuitClubs: self.suitLabel.text = @"♣"; break;
        case CardSuitDiamonds: self.suitLabel.text = @"♦"; break;
        case CardSuitHearts: self.suitLabel.text = @"♥"; break;
        case CardSuitSpades: self.suitLabel.text = @"♠"; break;
    }
    
    if (suit == CardSuitSpades || suit == CardSuitClubs) {
        self.rankLabel.textColor = self.suitLabel.textColor = [UIColor blackColor];
    } else {
        self.rankLabel.textColor = self.suitLabel.textColor = [UIColor redColor];
    }
}

@end
