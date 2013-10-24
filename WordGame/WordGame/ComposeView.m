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
        _iiResult = II_NULL;
        _items = [[NSMutableArray alloc] init];
        _slots = [[NSMutableArray alloc] init];
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
        if (!_bHasScroll) // no scroll here or all needed items here
            return IDS_NOSCROLL;
        if (_items.count == _slots.count) // All needed items have been put here
            return IDS_FULL;
        // to check if the dropped item is the one in the formula
        BOOL bValid = NO;
        UIImageView* ivSlot = nil;
        for (int i = 0; i < _slots.count; i++)
        {
            ivSlot = [_slots objectAtIndex:i];
            ItemIndex iiIndex = ivSlot.tag;
            if (iiIndex == item)
            {
                bValid = YES;
                [_items addObject:[NSNumber numberWithInt:iiIndex]];
                break;
            }
        }
        if (!bValid)
            return IDS_NONFITITEM;
        // to put the item
        ivSlot.image =
            [UIImage imageNamed:[NSString stringWithFormat:@"%s%s", PREFIX_AVAIL, ITEM[ivSlot.tag]]];
        // All items needed have been placed
        if (_items.count == _slots.count)
            [self showComposeButton:@"Compose"];
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
        [self showCancelButton:@"Cancel"];
        return IDS_SUCCESS;
    }
    return IDS_INVALID;
}

- (void)discard
{
    // to hide the result item
    [_ivResult setHidden:YES];
    // to hide the buttons
    [_btnCancel setHidden:YES];
    [_btnCompose setHidden:YES];
    // no scrolls
    _bHasScroll = NO;
}

///*** PRIVATE ***///
//** EVENTS **///
- (void)cancelWasTapped:(id)sender
{
    NSString* strTitle = _btnCancel.titleLabel.text;
    if ([strTitle isEqualToString:@"Cancel"])
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
        [_delegate cancelWasTapped:ptCenter scroll:_iiScroll items:_items];
        // no scrolls now
        _bHasScroll = NO;
        // no items now
        [_items removeAllObjects];
    } else if ([strTitle isEqualToString:@"Discard"])
    {
        if (_btnCancel.alpha <= .7)
            return; // The button is now being animated
        // no items now
        [_items removeAllObjects];
        [_delegate discardWasTapped:_iiResult];
    }
}

- (void)composeWasTapped:(id)sender
{
    NSString* strTitle = _btnCompose.titleLabel.text;
    if ([strTitle isEqualToString:@"Compose"])
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
                                      if (i != 0)
                                          return;
                                      // the coordinate of the result
                                      CGFloat fCenterX =
                                        self.frame.origin.x + self.frame.size.width * PERCENTAGE_WIDTH_SLOTAREA * .6;
                                      CGFloat fCenterY = self.center.y;
                                      CGFloat fWidth = self.frame.size.height * PERCENTAGE_HEIGHT_RESULT;
                                      CGRect rcResult = CGRectMake(fCenterX - fWidth / 2,
                                                                   fCenterY - fWidth / 2,
                                                                   fWidth,
                                                                   fWidth);
                                      if (!_ivResult)
                                      {
                                          // to be faded in the final composition
                                          _ivResult = [[UIImageView alloc] initWithFrame:rcResult];
                                          // to put this view to the back
                                          // so that particle effects will be on top of it
                                          _ivResult.layer.zPosition = -10;
                                          [self addSubview:_ivResult];
                                      } else // to reset the result item's frame
                                          _ivResult.frame = rcResult;
                                      // the result
                                      _iiResult = FORMULA_COMPOSITION[_iiScroll];
                                      _ivResult.alpha = 0;
                                      _ivResult.image =
                                      [UIImage imageNamed:
                                       [NSString stringWithFormat:@"%s%s", PREFIX_AVAIL,
                                        ITEM[_iiResult]]];
                                      [_ivResult setHidden:NO];
                                      [UIImageView animateWithDuration:TIME_COMPOSE
                                                            animations:^{
                                                                _ivResult.alpha = 1;
                                                            } completion:^(BOOL finished){
                                                                [self compositionDidFinish];
                                                            }];
                                  }];
        }
        // to hide buttons
        [_btnCompose setHidden:YES];
        [_btnCancel setHidden:YES];
        // the particle effects
        [self fireParticles];
    } else if ([strTitle isEqualToString:@"OK"])
    {
        if (_btnCompose.alpha <= .7)
            return; // The button is now being animated.
        // to hide all things
        [_ivResult setHidden:YES];
        [_btnCancel setHidden:YES];
        [_btnCompose setHidden:YES];
        [_delegate okWasTapped:_iiResult];
        // no scrolls now
        _bHasScroll = NO;
        // no items
        [_items removeAllObjects];
    }
}

- (void)particlesShouldBeRemoved
{
    [_el removeFromSuperlayer];
}

- (void)compositionDidFinish
{
    // to hide buttons for later animation
    _btnCancel.alpha = 0;
    _btnCompose.alpha = 0;
    // to change the button title
    [self showCancelButton:@"Discard"];
    [self showComposeButton:@"OK"];
    // to animate these buttons
    [UIButton animateWithDuration:1
                       animations:^{
                           _btnCancel.alpha = 1;
                           _btnCompose.alpha = 1;
                       }
                       completion:nil];
    // to animate the result
    [UIImageView animateWithDuration:.7
                               delay:2
                             options:UIViewAnimationOptionCurveLinear
                          animations:^{
                              _ivResult.frame = CGRectMake(5, 5, 35, 35);
                          }
                          completion:^(BOOL finished) {
                              // to show the item description
                          }];
}
//** END OF EVENTS **//

- (void)showCancelButton:(NSString*)title
{
    if (!_btnCancel)
    {
        // the position of the cancel button
        CGFloat fX =
            self.frame.origin.x + self.frame.size.width - BUTTON_OFFSET - BUTTON_WIDTH;
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
        [_btnCancel setTitle:title forState:UIControlStateNormal];
        [_btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _btnCancel.titleLabel.shadowColor = [UIColor lightGrayColor];
        _btnCancel.titleLabel.shadowOffset = CGSizeMake(0, -1);
        [self addSubview:_btnCancel];
    } else
    {
        [_btnCancel setHidden:NO];
        // to change the title because this button can be Cancel or Discard
        if (![_btnCancel.titleLabel.text isEqualToString:title])
            [_btnCancel setTitle:title forState:UIControlStateNormal];
    }
}

- (void)showComposeButton:(NSString*)title
{
    if (!_btnCompose)
    {
        // the position of the compose button
        CGFloat fX =
            self.frame.origin.x + self.frame.size.width - BUTTON_OFFSET - BUTTON_WIDTH;
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
        [_btnCompose setTitle:title forState:UIControlStateNormal];
        [_btnCompose setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _btnCompose.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _btnCompose.titleLabel.shadowColor = [UIColor lightGrayColor];
        _btnCompose.titleLabel.shadowOffset = CGSizeMake(0, -1);
        [self addSubview:_btnCompose];
    } else
    {
        [_btnCompose setHidden:NO];
        // to change the title because this button can be Compose or OK
        if (![_btnCompose.titleLabel.text isEqualToString:title])
            [_btnCompose setTitle:title forState:UIControlStateNormal];
    }
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
