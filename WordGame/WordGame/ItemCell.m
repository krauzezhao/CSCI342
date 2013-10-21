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
    }
    return self;
}

- (void)setItem:(ItemIndex)item number:(int)num
{
    _item = item;
    if (num == II_UNKNOWN)
    {
        _ivItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"%s", ITEM_UNKNOWN]];
        _item = II_UNKNOWN;
    }
    else if (num == II_UNAVAIL)
        _ivItem.image =
            [UIImage imageNamed:[NSString stringWithFormat:@"%s%s", PREFIX_UNAVAIL, ITEM[item]]];
    else
    {
        _ivItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"%s%s", PREFIX_AVAIL, ITEM[item]]];
        // the number of items
        _lblNum.text = [NSString stringWithFormat:@"X%d", num];
        // the pan gesture
        // This item can be dragged
        UIPanGestureRecognizer* pgr =
            [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(itemIsBeingDragged:)];
        _ivItem.userInteractionEnabled = YES;
        [_ivItem addGestureRecognizer:pgr];
    }

}

///*** PRIVATE ***///
//** INIT **//
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
    _lblNum.font = [UIFont boldSystemFontOfSize:16];
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
    _ivItem.layer.cornerRadius = 5;
    [_vContent addSubview:_ivItem];
}
//** END OF INIT **//

// events
- (void)itemIsBeingDragged:(UIPanGestureRecognizer *)pgr
{
    if (pgr.state == UIGestureRecognizerStateEnded)
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIME_RETURN / 2
                                                  target:self
                                                selector:@selector(itemShouldAppear)
                                                userInfo:nil
                                                 repeats:NO];
    else if (pgr.state == UIGestureRecognizerStateBegan)
        [_ivItem setHidden:YES];
    // to trigger the delegate method
    [_delegate itemIsBeingDragged:pgr
                           center:_ivItem.center
                              ref:[pgr locationInView:self]
                            item:_item];
}

- (void)itemShouldAppear
{
    [_ivItem setHidden:NO];
    [_timer invalidate];
}
///*** END OF PRIVATE ***///

@end
