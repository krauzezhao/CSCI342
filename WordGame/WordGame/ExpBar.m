//
//  ExpBar.m
//  WordGame
//
//  Created by Brendan Dickinson on 11/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "ExpBar.h"

@implementation ExpBar

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initLevelLabel];
        [self initExpLabel];
        [self initExpBar];
    }
    return self;
}

///*** INIT ***///
- (void)initLevelLabel
{
    _lblLevel = [[UILabel alloc] init];
    _lblLevel.backgroundColor = [UIColor clearColor];
    _lblLevel.text = @"Level Here";
    [_lblLevel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_lblLevel];
    // constraints
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_lblLevel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblLevel
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblLevel
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:.5
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblLevel
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:.5
                                       constant:0];
    [self addConstraint:lc];
}

- (void)initExpLabel
{
    _lblExpPoints = [[UILabel alloc] init];
    _lblExpPoints.backgroundColor = [UIColor clearColor];
    _lblExpPoints.text = @"Exp Points Here";
    [_lblExpPoints setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_lblExpPoints];
    // constraints
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_lblExpPoints
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblExpPoints
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblExpPoints
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:.5
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblExpPoints
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:.5
                                       constant:0];
    [self addConstraint:lc];
}

- (void)initExpBar
{

    _pvExp = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _pvExp.progress = .5;
    [_pvExp setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_pvExp];
    // constraint
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_pvExp
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_pvExp
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_pvExp
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1
                                       constant:0];
    [self addConstraint:lc];
}
///*** END OF INIT ***///

@end
