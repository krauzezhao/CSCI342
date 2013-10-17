//
//  WordCell.m
//  WordGame
//
//  Created by Brendan Dickinson on 16/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "WordCell.h"

@implementation WordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initTitle];
        [self initInfoTitle];
        [self initSubtitle];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title
{
    _lblTitle.text = title;
}

- (void)setInfoTitle:(NSString *)info
{
    _lblInfoTitle.text = info;
}

- (void)setSubtitle:(NSString *)subtitle
{
    if (!subtitle)
        [_lblSubtitle removeFromSuperview];
    _lblSubtitle.text = subtitle;
}

///*** PRIVATE ***///
// init
- (void)initTitle
{
    _lblTitle = [[UILabel alloc] init];
    [_lblTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_lblTitle];
    // constraints
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_lblTitle
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:PADDING_HORIZONTAL];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblTitle
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:PADDING_VERTICAL];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblTitle
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:PERCENTAGE_WIDTH_TITLE
                                       constant:0];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblTitle
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:.5
                                       constant:0];
    [self.contentView addConstraint:lc];
}

- (void)initInfoTitle
{
    _lblInfoTitle = [[UILabel alloc] init];
    _lblInfoTitle.font = [UIFont systemFontOfSize:12];
    _lblInfoTitle.textColor = [UIColor grayColor];
    [_lblInfoTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_lblInfoTitle];
    // constraints
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_lblInfoTitle
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0 - PADDING_HORIZONTAL];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblInfoTitle
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:PADDING_VERTICAL];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblInfoTitle
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:1 - PERCENTAGE_WIDTH_TITLE
                                       constant:0];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblInfoTitle
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:.5
                                       constant:0];
    [self.contentView addConstraint:lc];

}

- (void)initSubtitle
{
    _lblSubtitle = [[UILabel alloc] init];
    _lblSubtitle.font = [UIFont systemFontOfSize:12];
    _lblSubtitle.textColor = [UIColor grayColor];
    [_lblSubtitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_lblSubtitle];
    // constraints
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_lblSubtitle
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:PADDING_HORIZONTAL];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblSubtitle
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:PADDING_VERTICAL];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblSubtitle
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:1
                                       constant:0];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblSubtitle
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:.5
                                       constant:0];
    [self.contentView addConstraint:lc];
}
///*** END OF PRIVATE ***///

@end