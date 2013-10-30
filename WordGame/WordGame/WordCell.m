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
        [self initSubtitleLeft];
        [self initSubtitleRight];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (void)setInfoTitle:(NSString *)info
{
    _infoTitleLabel.text = info;
}

- (void)setSubtitleLeft:(NSString *)subtitle
{
    if (!subtitle)
        [_leftSubtitleLabel removeFromSuperview];
    _leftSubtitleLabel.text = subtitle;
}

- (void)setSubtitleRight:(NSString *)subtitle
{
    if (!subtitle)
        [_rightSubtitleLabel removeFromSuperview];
    _rightSubtitleLabel.text = subtitle;
}

///*** PRIVATE ***///
// init
- (void)initTitle
{
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_titleLabel];
    // constraints
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_titleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:PADDING_HORIZONTAL];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_titleLabel
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:PADDING_VERTICAL];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_titleLabel
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:PERCENTAGE_WIDTH_TITLE
                                       constant:0];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_titleLabel
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
    _infoTitleLabel = [[UILabel alloc] init];
    _infoTitleLabel.font = [UIFont systemFontOfSize:12];
    _infoTitleLabel.textAlignment = NSTextAlignmentRight;
    _infoTitleLabel.textColor = [UIColor grayColor];
    [_infoTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_infoTitleLabel];
    // constraints
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_infoTitleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0 - PADDING_HORIZONTAL];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_infoTitleLabel
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:PADDING_VERTICAL];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_infoTitleLabel
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:1 - PERCENTAGE_WIDTH_TITLE
                                       constant:0];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_infoTitleLabel
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:.5
                                       constant:0];
    [self.contentView addConstraint:lc];

}

- (void)initSubtitleLeft
{
    _leftSubtitleLabel = [[UILabel alloc] init];
    _leftSubtitleLabel.font = [UIFont systemFontOfSize:12];
    _leftSubtitleLabel.textColor = [UIColor grayColor];
    [_leftSubtitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_leftSubtitleLabel];
    // constraints
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_leftSubtitleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:PADDING_HORIZONTAL];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_leftSubtitleLabel
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:PADDING_VERTICAL];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_leftSubtitleLabel
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:.5
                                       constant:0];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_leftSubtitleLabel
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:.5
                                       constant:0];
    [self.contentView addConstraint:lc];
}

- (void)initSubtitleRight
{
    _rightSubtitleLabel = [[UILabel alloc] init];
    _rightSubtitleLabel.font = [UIFont systemFontOfSize:12];
    _rightSubtitleLabel.textAlignment = NSTextAlignmentRight;
    _rightSubtitleLabel.textColor = [UIColor grayColor];
    [_rightSubtitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_rightSubtitleLabel];
    // constraints
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_rightSubtitleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0 - PADDING_HORIZONTAL];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_rightSubtitleLabel
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:PADDING_VERTICAL];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_rightSubtitleLabel
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:.5
                                       constant:0];
    [self.contentView addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_rightSubtitleLabel
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
