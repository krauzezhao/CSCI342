//
//  UsableItemView.m
//  WordGame
//
//  Created by Brendan Dickinson on 22/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "UsableItemView.h"

@implementation UsableItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // GUI
        self.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        // the timer-related info
        _nTicks = 0;
        // the item image view
        _ivItems = [[NSMutableArray alloc] init];
        // the labels
        _lblNum = [[NSMutableArray alloc] init];
        // the swipe gesture to hide the view
        UISwipeGestureRecognizer* sgr =
            [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(viewWasSwipedOver)];
        sgr.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:sgr];
    }
    return self;
}

// init
- (void)initItems:(NSMutableArray*)numOfItems
{
    if (_ivItems.count == 0)
    {
        // the size of the item area
        CGFloat fWidthUnit = self.frame.size.width / NUM_USABLE;
        CGFloat fWidth = fWidthUnit * PERCENTAGE_ITEM_UNIT;
        CGFloat fHeight = self.frame.size.height;
        for (int i = 0; i < NUM_USABLE; i++)
        {
            CGRect rc = CGRectMake((fWidthUnit - fWidth) / 2 + fWidthUnit * i,
                                   (self.frame.size.height - fWidth) / 2,
                                   fWidth,
                                   fHeight);
            UIImageView* iv = [[UIImageView alloc] initWithFrame:rc];
            iv.backgroundColor = [UIColor clearColor];
            // the labels
            rc = CGRectMake(iv.frame.origin.x,
                            iv.frame.origin.y + iv.frame.size.height - 10,
                            iv.frame.size.width + 10,
                            15);
            UILabel* lbl = [[UILabel alloc] initWithFrame:rc];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.font = [UIFont boldSystemFontOfSize:14];
            lbl.textAlignment = NSTextAlignmentRight;
            lbl.textColor = [UIColor whiteColor];
            lbl.layer.zPosition = 10; // to keep the label at the top
            [self addSubview:lbl];
            [_lblNum addObject:lbl];
            // the number of items
            int nNum = [[numOfItems objectAtIndex:i] intValue];
            iv.tag = nNum; // The image view tag is the number of the item.
            if (nNum > 0) // available
            {
                iv.image =
                    [UIImage imageNamed:[NSString stringWithFormat:@"%s%s", PREFIX_AVAIL, USABLE[i]]];
                lbl.text = [NSString stringWithFormat:@"X%d", nNum];
            }
            else if (nNum == 0) // unavailable
                iv.image =
                    [UIImage imageNamed:[NSString stringWithFormat:@"%s%s", PREFIX_UNAVAIL, USABLE[i]]];
            else if (nNum == II_UNKNOWN) // unknown
                iv.image =
                    [UIImage imageNamed:[NSString stringWithFormat:@"%s", ITEM_UNKNOWN]];
            // the tap gesture to use the item
            iv.userInteractionEnabled = YES;
            UITapGestureRecognizer* tgr =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(itemWasTapped:)];
            tgr.numberOfTapsRequired = 1;
            [iv addGestureRecognizer:tgr];
            // to add the image view
            [self addSubview:iv];
            [_ivItems addObject:iv];
        }
    }
}

///*** PRIVATE ***///
// events
- (void)viewWasSwipedOver
{
    [_delegate usableItemViewWasSwipedOver];
}

- (void)itemWasTapped:(UITapGestureRecognizer*)tgr
{
    // to get the index of the tapped item
    int nIndex = -1;
    for (int i = 0; i < _ivItems.count; i++)
        if (tgr.view == [_ivItems objectAtIndex:i])
        {
            nIndex = i;
            break;
        }
    if (nIndex == -1)
        return;
    // Unknown items cannot be selected
    UIImageView* iv = [_ivItems objectAtIndex:nIndex];
    if (iv.tag == II_UNKNOWN || iv.tag == 0)
        return;
    // to update the number
    int nNum = iv.tag;
    nNum--;
    iv.tag = nNum;
    UILabel* lbl = [_lblNum objectAtIndex:nIndex];
    if (nNum == 0)
    {
        lbl.text = @"";
        iv.image =
            [UIImage imageNamed:[NSString stringWithFormat:@"%s%s", PREFIX_UNAVAIL, USABLE[nIndex]]];
    }
    else if (nNum > 0)
        lbl.text = [NSString stringWithFormat:@"X%d", nNum];
    // to highlight the selection
    _timer = [NSTimer scheduledTimerWithTimeInterval:.1
                                              target:self
                                            selector:@selector(itemShouldBeHighlighted:)
                                            userInfo:iv
                                             repeats:YES];
    [_delegate usableItemWasSelected:USABLE_INDEX[nIndex]];
}

- (void)itemShouldBeHighlighted:(NSTimer *)timer
{
    UIImageView* iv = (UIImageView*)timer.userInfo;
    if (_nTicks++ % 2 == 0)
    {
        iv.layer.borderColor = [UIColor colorWithRed:.4 green:1 blue:1 alpha:.8].CGColor;
        iv.layer.borderWidth = 2;
    } else
        iv.layer.borderWidth = 0;
    if (_nTicks == NUM_BORDER_FLASH)
    {
        _nTicks = 0;
        [_timer invalidate];
        // to hide the view
        [self viewWasSwipedOver];
    }
}
///*** END OF PRIVATE ***///
@end
