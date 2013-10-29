//
//  ItemDescriptionView.m
//  WordGame
//
//  Created by Brendan Dickinson on 29/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "ItemDescriptionView.h"

@implementation ItemDescriptionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.alpha = .8;
        self.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    }
    return self;
}

- (void)setItem:(ItemIndex)item
{
    if (!_lblName)
        [self initNameLabel];
    if (!_tvDescription)
        [self initDescriptionTextView];
    _lblName.text = [NSString stringWithFormat:@"%s", ITEM_NAME[item]];
    _tvDescription.text = [NSString stringWithFormat:@"%s", ITEM_DESCRIPTION[item]];
}

///*** PRIVATE ***///
// init
- (void)initNameLabel
{
    // the label
    _lblName = [[UILabel alloc] init];
    _lblName.backgroundColor = [UIColor clearColor];
    _lblName.font = [UIFont boldSystemFontOfSize:12];
    _lblName.textColor = [UIColor yellowColor];
    [_lblName setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_lblName];
    // constraints
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_lblName
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:IDV_PADDING];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblName
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:IDV_PADDING];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblName
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:1
                                       constant:0 - 2 * IDV_PADDING];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblName
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:PERCENTAGE_HEIGHT_NAMELABEL
                                       constant:0 - IDV_PADDING];
    [self addConstraint:lc];
}

- (void)initDescriptionTextView
{
    // the text view
    _tvDescription = [[UITextView alloc] init];
    _tvDescription.backgroundColor = [UIColor clearColor];
    _tvDescription.editable = NO;
    _tvDescription.scrollEnabled = YES;
    _tvDescription.textColor = [UIColor whiteColor];
    [_tvDescription setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_tvDescription];
    // constraints
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_tvDescription
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:IDV_PADDING];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_tvDescription
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:_lblName
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:IDV_PADDING];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_tvDescription
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1
                                       constant:0 - IDV_PADDING];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_tvDescription
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:IDV_PADDING];
    [self addConstraint:lc];
}
///*** END OF PRIVATE ***///

@end
