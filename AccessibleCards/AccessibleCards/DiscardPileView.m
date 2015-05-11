//
//  DiscardPileView.m
//  AccessibleCards
//
//  Created by Dylan Sturgeon on 5/11/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "DiscardPileView.h"

@interface DiscardPileView ()

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
    return NSLocalizedString(@"Discard pile", @"accessibility label for DiscardPileView");
}

- (NSString *)accessibilityHint {
    return NSLocalizedString(@"Flips a card", @"accessibility hint for DiscardPileView");
}

# pragma mark Private
- (void) tapped: (id) sender {
    NSLog(@"Discard Pile Tapped");
}

@end
