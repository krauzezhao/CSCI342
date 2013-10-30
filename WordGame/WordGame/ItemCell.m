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
    _numberLabel.text = @"";
    _itemImageView.tag = num; // The tag is the number of the item.
    if (num == II_UNKNOWN)
    {
        _itemImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%s", ITEM_UNKNOWN]];
        _item = II_UNKNOWN;
    }
    else if (num == II_UNAVAIL || num == 0)
        _itemImageView.image =
            [UIImage imageNamed:[NSString stringWithFormat:@"%s%s", PREFIX_UNAVAIL, ITEM[item]]];
    else
    {
        _itemImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%s%s", PREFIX_AVAIL, ITEM[item]]];
        // the number of items
        _numberLabel.text = [NSString stringWithFormat:@"X%d", num];
        _bUnavail = NO;
        // the pan gesture
        // This item can be dragged
        UIPanGestureRecognizer* pgr =
            [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(itemIsBeingDragged:)];
        _itemImageView.userInteractionEnabled = YES;
        [_itemImageView addGestureRecognizer:pgr];
        // the tap gesture to show the item description
        UITapGestureRecognizer* tgr =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(itemWasTapped:)];
        tgr.numberOfTapsRequired = 1;
        [_itemImageView addGestureRecognizer:tgr];
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
    _contentView = [[UIView alloc] initWithFrame:rcContent];
    [self addSubview:_contentView];
}

- (void)initLabel
{
    // the label rect
    CGRect rcLabel = CGRectMake(0,
                                _contentView.frame.size.height * (1 - PERCENTAGE_HEIGHT_LABEL),
                                _contentView.frame.size.width,
                                _contentView.frame.size.height * PERCENTAGE_HEIGHT_LABEL);
    // the label
    _numberLabel = [[UILabel alloc] initWithFrame:rcLabel];
    _numberLabel.backgroundColor = [UIColor clearColor];
    _numberLabel.font = [UIFont boldSystemFontOfSize:16];
    _numberLabel.textAlignment = NSTextAlignmentRight;
    _numberLabel.textColor = [UIColor whiteColor];
    [_contentView addSubview:_numberLabel];
}

- (void)initItem
{
    // the item frame
    CGRect rcItem = CGRectMake(PADDING_IMAGE,
                               PADDING_IMAGE,
                               _contentView.frame.size.width - 2 * PADDING_IMAGE,
                               _contentView.frame.size.height - 2 * PADDING_IMAGE);
    // the item
    _itemImageView = [[UIImageView alloc] initWithFrame:rcItem];
    _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    _itemImageView.layer.cornerRadius = 5;
    [_contentView addSubview:_itemImageView];
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
        if (_itemImageView.tag <= 0)
        {
            _bUnavail = YES;
            return; // The tag is the number of this item.
        }
        [_itemImageView setHidden:YES];
    }
    // to trigger the delegate method
    if (!_bUnavail)
        [_delegate itemIsBeingDragged:pgr
                               center:_itemImageView.center
                                  ref:[pgr locationInView:self]
                                 item:_item];
}

- (void)itemWasTapped:(UITapGestureRecognizer *)tgr
{
    [_delegate itemWasTapped:tgr
                      center:_itemImageView.center
                         ref:[tgr locationInView:self]
                        item:_item];
}

- (void)itemShouldAppear
{
    [_itemImageView setHidden:NO];
    [_timer invalidate];
}

- (void)itemShouldBeHighlighted
{
    if (_nTicks++ % 2 == 0)
    {
        _itemImageView.layer.borderColor = [UIColor colorWithRed:.4 green:1 blue:1 alpha:.8].CGColor;
        _itemImageView.layer.borderWidth = 2;
    } else
        _itemImageView.layer.borderWidth = 0;
    if (_nTicks == 10)
    {
        _nTicks = 0;
        [_timer invalidate];
    }
}
///*** END OF PRIVATE ***///

@end
