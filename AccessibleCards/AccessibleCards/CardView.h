//
//  CardView.h
//  HWAccessibleCards
//
//  Created by Tim Ekl on 2/7/15.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CardSuit) {
    CardSuitClubs,
    CardSuitDiamonds,
    CardSuitHearts,
    CardSuitSpades,
};

typedef NS_ENUM(NSUInteger, CardRank) {
    CardRankAce,
    CardRankTwo,
    CardRankThree,
    CardRankFour,
    CardRankFive,
    CardRankSix,
    CardRankSeven,
    CardRankEight,
    CardRankNine,
    CardRankTen,
    CardRankJack,
    CardRankQueen,
    CardRankKing,
};

@interface CardView : UIView

@property (nonatomic, assign) CardRank rank;
@property (nonatomic, assign) CardSuit suit;

+ (NSArray *)shuffledDeck;

- (id)initWithRank:(CardRank)rank suit:(CardSuit)suit;

@end
