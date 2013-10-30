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
    if (!_nameLabel)
        [self initNameLabel];
    if (!_descriptionTextView)
        [self initDescriptionTextView];
    _nameLabel.text = [NSString stringWithFormat:@"%s", ITEM_NAME[item]];
    _descriptionTextView.text = [NSString stringWithFormat:@"%s", ITEM_DESCRIPTION[item]];
}

///*** PRIVATE ***///
// init
- (void)initNameLabel
{
    // the label
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:12];
    _nameLabel.textColor = [UIColor yellowColor];
    [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_nameLabel];
    // constraints
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_nameLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:IDV_PADDING];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_nameLabel
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:IDV_PADDING];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_nameLabel
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:1
                                       constant:0 - 2 * IDV_PADDING];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_nameLabel
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
    _descriptionTextView = [[UITextView alloc] init];
    _descriptionTextView.backgroundColor = [UIColor clearColor];
    _descriptionTextView.editable = NO;
    _descriptionTextView.scrollEnabled = YES;
    _descriptionTextView.textColor = [UIColor whiteColor];
    [_descriptionTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_descriptionTextView];
    // constraints
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_descriptionTextView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:IDV_PADDING];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_descriptionTextView
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:_nameLabel
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:IDV_PADDING];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_descriptionTextView
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1
                                       constant:0 - IDV_PADDING];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_descriptionTextView
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
