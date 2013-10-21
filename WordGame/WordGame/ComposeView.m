//
//  ComposeView.m
//  WordGame
//
//  Created by Brendan Dickinson on 20/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "ComposeView.h"

@implementation ComposeView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        _bHasScroll = NO;
        _slots = [[NSMutableArray alloc] init];
        // to init the hightlights
        _highlights = [[NSMutableArray alloc] init];
        for (int i = 0; i < NUM_HIGHLIGHTS; i++)
        {
            // the view
            CGRect rc = CGRectMake(i * HIGHLIGHT_WIDTH, 0, HIGHLIGHT_WIDTH, HIGHLIGHT_HEIGHT);
            UIView* v = [[UIView alloc] initWithFrame:rc];
            v.backgroundColor = [UIColor colorWithRed:1
                                                green:1
                                                 blue:i * 1.0 / NUM_HIGHLIGHTS
                                                alpha:1.0 / NUM_HIGHLIGHTS * (NUM_HIGHLIGHTS - i)];
            //[self addSubview:v];
            [_highlights addObject:v];
        }
        // the animation timer
//        [NSTimer scheduledTimerWithTimeInterval:.005
//                                         target:self
//                                       selector:@selector(highlightShouldBeMoved:)
//                                       userInfo:nil
//                                        repeats:YES];
    }
    return self;
}

- (ItemDropStatus)itemWasDropped:(ItemIndex)item
{
    // to determine the type
    ItemType type = IT_NULL;
    if (item >= II_SCROLL_WATCH && item <= II_SCROLL_MAGNIFIER)
        type = IT_SCROLL;
    else
        type = IT_ITEM;
    // to put the item
    if (type == IT_ITEM)
    {
        if (!_bHasScroll) // no scroll here
            return IDS_NOSCROLL;
        // to check if the dropped item is the item in the formula
        BOOL bValid = NO;
        UIImageView* ivSlot = nil;
        for (int i = 0; i < _slots.count; i++)
        {
            ivSlot = [_slots objectAtIndex:i];
            ItemIndex iiIndex = ivSlot.tag;
            if (iiIndex == item)
            {
                bValid = YES;
                break;
            }
        }
        if (!bValid)
            return IDS_NONFITITEM;
        // to put the item
        ivSlot.image =
        [UIImage imageNamed:[NSString stringWithFormat:@"%s%s", PREFIX_AVAIL, ITEM[ivSlot.tag]]];
        return IDS_SUCCESS;
    } else if (type == IT_SCROLL)
    {
        if (_bHasScroll) // already a scroll
            return IDS_ANOTHERSCROLL;
        // to initialise the slots
        [_slots removeAllObjects];
        // to compute the slot size by the number of items
        int nNumItems = FORMULA_NUM_ITEMS[item];
        CGFloat fWidthPerUnit = self.frame.size.width * PERCENTAGE_WIDTH_SLOTAREA / nNumItems;
        CGFloat fWidth = fWidthPerUnit * PERCENTAGE_WIDTH_SLOT;
        CGFloat fInitialX = (fWidthPerUnit - fWidth) / 2;
        CGFloat fY = (self.frame.size.height - fWidth) / 2;
        // to layout the compose slots
        for (int i = 0; i < nNumItems; i++)
        {
            // the size
            CGRect rc = CGRectMake(fInitialX + i * fWidthPerUnit, fY, fWidth, fWidth);
            // the item index
            ItemIndex iiIndex = FORMULA[item][i];
            // the slot
            UIImageView* iv = [[UIImageView alloc] initWithFrame:rc];
            iv.image =
            [UIImage imageNamed:[NSString stringWithFormat:@"%s%s", PREFIX_UNAVAIL, ITEM[iiIndex]]];
            iv.tag = iiIndex; // The tag is the item index.
            [self addSubview:iv];
            [_slots addObject:iv];
        }
        _bHasScroll = YES;
        _iiScroll = item;
        [self showCancelButton];
        [self showComposeButton];
        return IDS_SUCCESS;
    }
    return IDS_INVALID;
}

///*** PRIVATE ***///
//** EVENTS **//
- (void)highlightShouldBeMoved:(NSTimer *)timer
{
    // the bottom right of this view
    _ptBottomRight.x = self.frame.origin.x + self.frame.size.width;
    _ptBottomRight.y = self.frame.origin.y + self.frame.size.height;
    // to get the highlight view
    //int nIndex = [timer.userInfo intValue];
    for (int i = 0; i < _highlights.count; i++)
    {
        UIView* v = [_highlights objectAtIndex:i];
        // to turn the highlight at the corner
        CGFloat fX = v.frame.origin.x;
        CGFloat fY = v.frame.origin.y;
        if (fX == 0 && fY == 0) // top left
            v.frame = CGRectMake(0, HIGHLIGHT_HEIGHT, HIGHLIGHT_WIDTH, HIGHLIGHT_HEIGHT);
        else if (fX == 0 && fY == _ptBottomRight.y - HIGHLIGHT_HEIGHT) // bottom left
            v.frame = CGRectMake(HIGHLIGHT_WIDTH, fY, HIGHLIGHT_WIDTH, HIGHLIGHT_HEIGHT);
        else if (fX == _ptBottomRight.x - HIGHLIGHT_WIDTH && fY == _ptBottomRight.y - HIGHLIGHT_HEIGHT)
            v.frame = CGRectMake(fX, // bottom right
                                 fY - HIGHLIGHT_HEIGHT,
                                 HIGHLIGHT_WIDTH,
                                 HIGHLIGHT_WIDTH);
        else if (fX == _ptBottomRight.x - HIGHLIGHT_WIDTH && fY == 0) // top right
            v.frame = CGRectMake(fX - HIGHLIGHT_WIDTH, fY, HIGHLIGHT_WIDTH, HIGHLIGHT_HEIGHT);
        else
        {
            // to move the highlight
            if (fY == 0) // top border
                v.frame = CGRectMake(fX - 1, fY, HIGHLIGHT_WIDTH, HIGHLIGHT_HEIGHT);
            else if (fX == 0) // left border
                v.frame = CGRectMake(fX, fY + 1, HIGHLIGHT_WIDTH, HIGHLIGHT_HEIGHT);
            else if (fY == _ptBottomRight.y - HIGHLIGHT_HEIGHT) // bottom border
                v.frame = CGRectMake(fX + 1, fY, HIGHLIGHT_WIDTH, HIGHLIGHT_HEIGHT);
            else if (fX == _ptBottomRight.x - HIGHLIGHT_WIDTH) // right border
                v.frame = CGRectMake(fX, fY - 1, HIGHLIGHT_WIDTH, HIGHLIGHT_HEIGHT);
        }
    }
}

- (void)cancelWasTapped:(id)sender
{
    // to remove all views
    for (int i = 0; i < _slots.count; i++)
    {
        UIImageView* iv = [_slots objectAtIndex:i];
        [UIImageView animateWithDuration:.2
                              animations:^{
                                  iv.alpha = 0;
                              }
                              completion:^(BOOL finished) {
                                  [iv removeFromSuperview];
                              }];
    }
    [_slots removeAllObjects];
    // to hide buttons
    [_btnCompose setHidden:YES];
    [_btnCancel setHidden:YES];
    // the delegate
    CGPoint ptCenter =
        CGPointMake((self.frame.origin.x + self.frame.size.width) * PERCENTAGE_WIDTH_SLOTAREA / 2,
                    (self.frame.origin.y + self.frame.size.height) / 2);
    [_delegate cancelWasTapped:ptCenter scroll:_iiScroll];
    // no scrolls now
    _bHasScroll = NO;
}

- (void)composeWasTapped:(id)sender
{
    // to fade out items
    for (int i = 0; i < _slots.count; i++)
    {
        UIImageView* iv = [_slots objectAtIndex:i];
        [UIImageView animateWithDuration:TIME_COMPOSE
                              animations:^{
                                  iv.alpha = 0;
                              }
                              completion:^(BOOL finished) {
                                  [iv removeFromSuperview];
                                  // to fade in the result
                                  if (i != _slots.count - 1)
                                      return;
                                  // the coordinate of the result
                                  CGFloat fCenterX = self.frame.origin.x + self.frame.size.width / 2;
                                  CGFloat fCenterY = self.center.y;
                                  CGFloat fWidth = self.frame.size.height * PERCENTAGE_HEIGHT_RESULT;
                                  CGRect rcResult = CGRectMake(fCenterX - fWidth / 2,
                                                               fCenterY - fWidth / 2,
                                                               fWidth,
                                                               fWidth);
                                  // to fade in the final composition
                                  UIImageView* ivResult = [[UIImageView alloc] initWithFrame:rcResult];
                                  ivResult.alpha = 0;
                                  ivResult.image =
                                  [UIImage imageNamed:
                                   [NSString stringWithFormat:@"%s%s", PREFIX_AVAIL, ITEM[FORMULA_COMPOSITION[_iiScroll]]]];
                                  // to put this view to the back
                                  // so that particle effects will be on top of it
                                  ivResult.layer.zPosition = -10;
                                  [self addSubview:ivResult];
                                  [UIImageView animateWithDuration:TIME_COMPOSE
                                                        animations:^{
                                                            ivResult.alpha = 1;
                                                        } completion:nil];
                              }];
    }
    // to hide buttons
    [_btnCompose setHidden:YES];
    [_btnCancel setHidden:YES];
    // the particle effects
    [self fireParticles];
}

- (void)particlesShouldBeRemoved
{
    [_el removeFromSuperlayer];
}
//** END OF EVENTS **//

- (void)showCancelButton
{
    if (!_btnCancel)
    {
        // the position of the cancel button
        CGFloat fX =
            self.frame.origin.x + self.frame.size.width - HIGHLIGHT_WIDTH - BUTTON_OFFSET - BUTTON_WIDTH;
        CGFloat fY = self.center.y + BUTTON_OFFSET;
        // to initialise it
        _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(fX, fY, BUTTON_WIDTH, BUTTON_HEIGHT)];
        [_btnCancel addTarget:self
                       action:@selector(cancelWasTapped:)
             forControlEvents:UIControlEventTouchUpInside];
        [_btnCancel setBackgroundImage:[[UIImage imageNamed:@"cancel.png"]
                                        stretchableImageWithLeftCapWidth:8
                                                            topCapHeight:0]
                              forState:UIControlStateNormal];
        [_btnCancel setBackgroundImage:[[UIImage imageNamed:@"cancel_pressed.png"]
                                        stretchableImageWithLeftCapWidth:8
                                                            topCapHeight:0]
                              forState:UIControlStateSelected];
        [_btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [_btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _btnCancel.titleLabel.shadowColor = [UIColor lightGrayColor];
        _btnCancel.titleLabel.shadowOffset = CGSizeMake(0, -1);
        [self addSubview:_btnCancel];
    } else
        [_btnCancel setHidden:NO];
}

- (void)showComposeButton
{
    if (!_btnCompose)
    {
        // the position of the compose button
        CGFloat fX =
            self.frame.origin.x + self.frame.size.width - HIGHLIGHT_WIDTH - BUTTON_OFFSET - BUTTON_WIDTH;
        CGFloat fY = self.center.y - BUTTON_OFFSET - BUTTON_HEIGHT;
        // to initialise it
        _btnCompose = [[UIButton alloc] initWithFrame:CGRectMake(fX, fY, BUTTON_WIDTH, BUTTON_HEIGHT)];
        [_btnCompose addTarget:self
                        action:@selector(composeWasTapped:)
              forControlEvents:UIControlEventTouchUpInside];
        [_btnCompose setBackgroundImage:[[UIImage imageNamed:@"compose.png"]
                                        stretchableImageWithLeftCapWidth:8
                                        topCapHeight:0]
                              forState:UIControlStateNormal];
        [_btnCompose setBackgroundImage:[[UIImage imageNamed:@"compose_pressed.png"]
                                        stretchableImageWithLeftCapWidth:8
                                        topCapHeight:0]
                              forState:UIControlStateSelected];
        [_btnCompose setTitle:@"Compose" forState:UIControlStateNormal];
        [_btnCompose setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _btnCompose.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _btnCompose.titleLabel.shadowColor = [UIColor lightGrayColor];
        _btnCompose.titleLabel.shadowOffset = CGSizeMake(0, -1);
        [self addSubview:_btnCompose];
    } else
        [_btnCompose setHidden:NO];
}

- (void)fireParticles
{
    // the cell
    CAEmitterCell* ec = [CAEmitterCell emitterCell];
    ec.birthRate = 500;
    ec.lifetime = 3;
    ec.lifetimeRange = .5;
    //ec.color = [[UIColor colorWithRed:.8 green:.4 blue:.2 alpha:.1] CGColor];
    ec.color = [[UIColor colorWithRed:1 green:1 blue:1 alpha:.2] CGColor];
    ec.contents = (id)[[UIImage imageNamed:@"particle.png"] CGImage];
    ec.scale = .1;
    ec.scaleRange = .2;
    ec.emissionRange = 3.14;
    ec.velocity = -100;
    ec.velocityRange = 20;
    // to initialise the layers
    _el = [CAEmitterLayer layer];
    _el.emitterPosition = CGPointMake(self.frame.origin.x + 10, self.center.y);
    _el.emitterSize = CGSizeMake(2, 2);
    // to configure the layer
    _el.emitterCells = [NSArray arrayWithObject:ec];
    _el.renderMode = kCAEmitterLayerAdditive;
    [self.layer addSublayer:_el];
    // the animation
    CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"emitterPosition"];
    ba.fromValue = [NSValue valueWithCGPoint:_el.emitterPosition];
    ba.toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width * 1.1,
                                                       _el.emitterPosition.y)];
    ba.duration = TIME_COMPOSE;
    ba.autoreverses = NO;
    ba.repeatCount = 1;
    ba.beginTime = CACurrentMediaTime() + .1;
    ba.delegate = self;
    ba.removedOnCompletion = YES;
    [_el addAnimation:ba forKey:nil];
}

// delegates
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // to move out the particle layer
    _el.emitterPosition = CGPointMake(-100, 0);
    // to delay the removel of the layer
    [NSTimer scheduledTimerWithTimeInterval:3
                                     target:self
                                   selector:@selector(particlesShouldBeRemoved)
                                   userInfo:nil
                                    repeats:NO];
}
@end
