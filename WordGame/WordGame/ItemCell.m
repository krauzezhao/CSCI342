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
        _nTicks = 0;
        _bUnavail = YES;
    }
    return self;
}

- (void)setItem:(ItemIndex)item number:(int)num
{
    _item = item;
    _lblNum.text = @"";
    _ivItem.tag = num; // The tag is the number of the item.
    if (num == II_UNKNOWN)
    {
        _ivItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"%s", ITEM_UNKNOWN]];
        _item = II_UNKNOWN;
    }
    else if (num == II_UNAVAIL || num == 0)
        _ivItem.image =
            [UIImage imageNamed:[NSString stringWithFormat:@"%s%s", PREFIX_UNAVAIL, ITEM[item]]];
    else
    {
        _ivItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"%s%s", PREFIX_AVAIL, ITEM[item]]];
        // the number of items
        _lblNum.text = [NSString stringWithFormat:@"X%d", num];
        _bUnavail = NO;
        // the pan gesture
        // This item can be dragged
        UIPanGestureRecognizer* pgr =
            [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(itemIsBeingDragged:)];
        _ivItem.userInteractionEnabled = YES;
        [_ivItem addGestureRecognizer:pgr];
        // the tap gesture to show the item description
        UITapGestureRecognizer* tgr =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(itemWasTapped:)];
        tgr.numberOfTapsRequired = 1;
        [_ivItem addGestureRecognizer:tgr];
    }
}

- (void)highlight
{
    // to highlight the selection
    _timer = [NSTimer scheduledTimerWithTimeInterval:.1
                                              target:self
                                            selector:@selector(itemShouldBeHighlighted)
                                            userInfo:nil
                                             repeats:YES];
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
    [self addSubview:_vContent];
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
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIME_RETURN / 2
                                                  target:self
                                                selector:@selector(itemShouldAppear)
                                                userInfo:nil
                                                 repeats:NO];
    }
    else if (pgr.state == UIGestureRecognizerStateBegan)
    {
        if (_ivItem.tag <= 0)
        {
            _bUnavail = YES;
            return; // The tag is the number of this item.
        }
        [_ivItem setHidden:YES];
    }
    // to trigger the delegate method
    if (!_bUnavail)
        [_delegate itemIsBeingDragged:pgr
                               center:_ivItem.center
                                  ref:[pgr locationInView:self]
                                 item:_item];
}

- (void)itemWasTapped:(UITapGestureRecognizer *)tgr
{
    [_delegate itemWasTapped:tgr
                      center:_ivItem.center
                         ref:[tgr locationInView:self]
                        item:_item];
}

- (void)itemShouldAppear
{
    [_ivItem setHidden:NO];
    [_timer invalidate];
}

- (void)itemShouldBeHighlighted
{
    if (_nTicks++ % 2 == 0)
    {
        _ivItem.layer.borderColor = [UIColor colorWithRed:.4 green:1 blue:1 alpha:.8].CGColor;
        _ivItem.layer.borderWidth = 2;
    } else
        _ivItem.layer.borderWidth = 0;
    if (_nTicks == 10)
    {
        _nTicks = 0;
        [_timer invalidate];
    }
}
///*** END OF PRIVATE ***///

@end
