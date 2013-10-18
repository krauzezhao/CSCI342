//
//  ItemCell.m
//  WordGame
//
//  Created by Brendan Dickinson on 18/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initContentView];
        [self initItem];
        [self initLabel];
        // the tap gesture
        self.userInteractionEnabled = YES;
        UIPanGestureRecognizer* pgr =
        [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(itemIsBeingDragged:)];
        [self addGestureRecognizer:pgr];
    }
    return self;
}

///*** PRIVATE ***///
- (void)initContentView
{
    CGRect rcContent = CGRectMake(self.frame.size.width * (1 - PERCENTAGE_CONTENTVIEW) / 2,
                                  self.frame.size.height * (1 - PERCENTAGE_CONTENTVIEW) / 2,
                                  self.frame.size.width * PERCENTAGE_CONTENTVIEW,
                                  self.frame.size.height * PERCENTAGE_CONTENTVIEW);
    _vContent = [[UIView alloc] initWithFrame:rcContent];
    //_vContent.backgroundColor = [UIColor grayColor];
    [self addSubview:_vContent];
}
- (void)initBorders
{
    ///*** NORTH BORDER ***////
    _vBorderNorth = [[UIView alloc] init];
    _vBorderNorth.alpha = .5;
    ///*** END OF NORTH BORDER ***///
}

- (void)initLabel
{
    // the label rect
    CGRect rcLabel = CGRectMake(0,
                                _vContent.frame.size.height * (1 - PERCENTAGE_HEIGHT_LABEL),
                                _vContent.frame.size.width,
                                _vContent.frame.size.height * PERCENTAGE_HEIGHT_LABEL);
    // the label
    _lblNum = [[UILabel alloc] initWithFrame:rcLabel];
    _lblNum.backgroundColor = [UIColor clearColor];
    _lblNum.font = [UIFont systemFontOfSize:14];
    _lblNum.text = @"X1";
    _lblNum.textAlignment = NSTextAlignmentRight;
    _lblNum.textColor = [UIColor whiteColor];
    [_vContent addSubview:_lblNum];
}

- (void)initItem
{
    // the item frame
    CGRect rcItem = CGRectMake(PADDING_IMAGE,
                               PADDING_IMAGE,
                               _vContent.frame.size.width - 2 * PADDING_IMAGE,
                               _vContent.frame.size.height - 2 * PADDING_IMAGE);
    // the item
    _ivItem = [[UIImageView alloc] initWithFrame:rcItem];
    _ivItem.contentMode = UIViewContentModeScaleAspectFit;
    _ivItem.image = [UIImage imageNamed:@"blue_A.ico"];
    _ivItem.layer.cornerRadius = 5;
    [_vContent addSubview:_ivItem];
}

// events
- (void)itemIsBeingDragged:(UIPanGestureRecognizer *)pgr
{
    if (pgr.state == UIGestureRecognizerStateBegan)
        [_ivItem setHidden:YES];
    else if (pgr.state == UIGestureRecognizerStateEnded)
        [_ivItem setHidden:NO];
    // to trigger the delegate method
    [_delegate itemIsBeingDragged:pgr
                           center:_ivItem.center
                              ref:[pgr locationInView:self]
                            image:@"blue_A.ico"];
}
///*** END OF PRIVATE ***///

@end
