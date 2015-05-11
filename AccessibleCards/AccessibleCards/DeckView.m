//
//  DeckView.m
//  AccessibleCards
//
//  Created by Dylan Sturgeon on 5/11/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "DeckView.h"

@interface DeckView ()

@property (strong, nonatomic) NSArray *cards;

@end

@implementation DeckView

- (void)awakeFromNib {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tapGesture];
}

# pragma mark UIAccessibility

- (BOOL)isAccessibilityElement {
    return YES;
}

- (NSString *)accessibilityLabel {
    return NSLocalizedString(@"Deck", @"accessibility label for DeckView");
}

- (NSString *)accessibilityHint {
    return NSLocalizedString(@"Shuffles the deck", @"accessibility hint for DeckView");
}

# pragma mark Private

- (void) tapped: (id) sender {
    NSLog(@"Deck Tapped");
}


@end
