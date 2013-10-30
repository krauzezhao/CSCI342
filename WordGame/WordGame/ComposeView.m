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
        _hasScroll = NO;
        _scroll = II_NULL;
        _result = II_NULL;
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
        if (!_hasScroll) // no scroll here or all needed items here
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
        if (_hasScroll) // already a scroll
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
        _hasScroll = YES;
        _scroll = item;
        [self showCancelButton:@"Cancel"];
        return IDS_SUCCESS;
    }
    return IDS_INVALID;
}

- (void)discard
{
    // to hide the result item
    [_resultImageView setHidden:YES];
    // to hide the descriptions
    [_nameLabel setHidden:YES];
    [_descriptionTextView setHidden:YES];
    // to hide the buttons
    [_cancelButton setHidden:YES];
    [_composeButton setHidden:YES];
    // no scrolls
    _hasScroll = NO;
}

///*** PRIVATE ***///
//** EVENTS **///
- (void)cancelWasTapped:(id)sender
{
    NSString* strTitle = _cancelButton.titleLabel.text;
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
        [_composeButton setHidden:YES];
        [_cancelButton setHidden:YES];
        // the delegate
        [_delegate cancelWasTapped:_scroll items:_items];
        // no scrolls now
        _hasScroll = NO;
        // no items now
        [_items removeAllObjects];
    } else if ([strTitle isEqualToString:@"Discard"])
    {
        if (_cancelButton.alpha <= .7)
            return; // The button is now being animated
        // no items now
        [_items removeAllObjects];
        [_delegate discardWasTapped:_result];
    }
}

- (void)composeWasTapped:(id)sender
{
    NSString* strTitle = _composeButton.titleLabel.text;
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
                                      if (!_resultImageView)
                                      {
                                          // to be faded in the final composition
                                          _resultImageView = [[UIImageView alloc] initWithFrame:rcResult];
                                          // to put this view to the back
                                          // so that particle effects will be on top of it
                                          _resultImageView.layer.zPosition = -10;
                                          [self addSubview:_resultImageView];
                                      } else // to reset the result item's frame
                                          _resultImageView.frame = rcResult;
                                      // the result
                                      _result = FORMULA_COMPOSITION[_scroll];
                                      _resultImageView.alpha = 0;
                                      _resultImageView.image =
                                      [UIImage imageNamed:
                                       [NSString stringWithFormat:@"%s%s", PREFIX_AVAIL,
                                        ITEM[_result]]];
                                      [_resultImageView setHidden:NO];
                                      [UIImageView animateWithDuration:TIME_COMPOSE
                                                            animations:^{
                                                                _resultImageView.alpha = 1;
                                                            } completion:^(BOOL finished){
                                                                [self compositionDidFinish];
                                                            }];
                                  }];
        }
        // to hide buttons
        [_composeButton setHidden:YES];
        [_cancelButton setHidden:YES];
        // the particle effects
        [self fireParticles];
    } else if ([strTitle isEqualToString:@"OK"])
    {
        if (_composeButton.alpha <= .7)
            return; // The button is now being animated.
        // to hide all things
        [_resultImageView setHidden:YES];
        [_nameLabel setHidden:YES];
        [_descriptionTextView setHidden:YES];
        [_cancelButton setHidden:YES];
        [_composeButton setHidden:YES];
        [_delegate okWasTapped:_result];
        // no scrolls now
        _hasScroll = NO;
        // no items
        [_items removeAllObjects];
    }
}

- (void)particlesShouldBeRemoved
{
    [_emitterLayer removeFromSuperlayer];
}

- (void)compositionDidFinish
{
    // to hide buttons for later animation
    _cancelButton.alpha = 0;
    _composeButton.alpha = 0;
    // to change the button title
    [self showCancelButton:@"Discard"];
    [self showComposeButton:@"OK"];
    // to animate these buttons
    [UIButton animateWithDuration:1
                       animations:^{
                           _cancelButton.alpha = 1;
                           _composeButton.alpha = 1;
                       }
                       completion:nil];
    // to animate the result
    [UIImageView animateWithDuration:.7
                               delay:2
                             options:UIViewAnimationOptionCurveLinear
                          animations:^{
                              _resultImageView.frame = CGRectMake(5, 5, 35, 35);
                          }
                          completion:^(BOOL finished) {
                              [self showDescription];
                          }];
}
//** END OF EVENTS **//

- (void)showCancelButton:(NSString*)title
{
    if (!_cancelButton)
    {
        // the position of the cancel button
        CGFloat fX =
            self.frame.origin.x + self.frame.size.width - BUTTON_OFFSET - BUTTON_WIDTH;
        CGFloat fY = self.center.y + BUTTON_OFFSET;
        // to initialise it
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(fX, fY, BUTTON_WIDTH, BUTTON_HEIGHT)];
        [_cancelButton addTarget:self
                       action:@selector(cancelWasTapped:)
             forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setBackgroundImage:[[UIImage imageNamed:@"cancel.png"]
                                        stretchableImageWithLeftCapWidth:8
                                                            topCapHeight:0]
                              forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[[UIImage imageNamed:@"cancel_pressed.png"]
                                        stretchableImageWithLeftCapWidth:8
                                                            topCapHeight:0]
                              forState:UIControlStateSelected];
        [_cancelButton setTitle:title forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _cancelButton.titleLabel.shadowColor = [UIColor lightGrayColor];
        _cancelButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
        [self addSubview:_cancelButton];
    } else
    {
        [_cancelButton setHidden:NO];
        // to change the title because this button can be Cancel or Discard
        if (![_cancelButton.titleLabel.text isEqualToString:title])
            [_cancelButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)showComposeButton:(NSString*)title
{
    if (!_composeButton)
    {
        // the position of the compose button
        CGFloat fX =
            self.frame.origin.x + self.frame.size.width - BUTTON_OFFSET - BUTTON_WIDTH;
        CGFloat fY = self.center.y - BUTTON_OFFSET - BUTTON_HEIGHT;
        // to initialise it
        _composeButton = [[UIButton alloc] initWithFrame:CGRectMake(fX, fY, BUTTON_WIDTH, BUTTON_HEIGHT)];
        [_composeButton addTarget:self
                        action:@selector(composeWasTapped:)
              forControlEvents:UIControlEventTouchUpInside];
        [_composeButton setBackgroundImage:[[UIImage imageNamed:@"compose.png"]
                                        stretchableImageWithLeftCapWidth:8
                                        topCapHeight:0]
                              forState:UIControlStateNormal];
        [_composeButton setBackgroundImage:[[UIImage imageNamed:@"compose_pressed.png"]
                                        stretchableImageWithLeftCapWidth:8
                                        topCapHeight:0]
                              forState:UIControlStateSelected];
        [_composeButton setTitle:title forState:UIControlStateNormal];
        [_composeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _composeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _composeButton.titleLabel.shadowColor = [UIColor lightGrayColor];
        _composeButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
        [self addSubview:_composeButton];
    } else
    {
        [_composeButton setHidden:NO];
        // to change the title because this button can be Compose or OK
        if (![_composeButton.titleLabel.text isEqualToString:title])
            [_composeButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)fireParticles
{
    // the cell
    CAEmitterCell* ec = [CAEmitterCell emitterCell];
    ec.birthRate = 800;
    ec.lifetime = 3;
    ec.lifetimeRange = .5;
    ec.color = [[UIColor colorWithRed:1 green:1 blue:1 alpha:.1] CGColor];
    ec.contents = (id)[[UIImage imageNamed:@"particle.png"] CGImage];
    ec.scale = .1;
    ec.scaleRange = .2;
    ec.emissionRange = 3.14;
    ec.velocity = -100;
    ec.velocityRange = 20;
    // to initialise the layers
    _emitterLayer = [CAEmitterLayer layer];
    _emitterLayer.emitterPosition = CGPointMake(self.frame.origin.x + 10, self.center.y);
    _emitterLayer.emitterSize = CGSizeMake(2, 2);
    // to configure the layer
    _emitterLayer.emitterCells = [NSArray arrayWithObject:ec];
    _emitterLayer.renderMode = kCAEmitterLayerAdditive;
    [self.layer addSublayer:_emitterLayer];
    // the animation
    CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"emitterPosition"];
    ba.fromValue = [NSValue valueWithCGPoint:_emitterLayer.emitterPosition];
    ba.toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width * 1.1,
                                                       _emitterLayer.emitterPosition.y)];
    ba.duration = TIME_COMPOSE;
    ba.autoreverses = NO;
    ba.repeatCount = 1;
    ba.beginTime = CACurrentMediaTime() + .1;
    ba.delegate = self;
    ba.removedOnCompletion = YES;
    [_emitterLayer addAnimation:ba forKey:nil];
}

- (void)showDescription
{
    ///*** NAME ***///
    if (!_nameLabel)
    {
        // the frame
        CGFloat fX = _resultImageView.frame.origin.x + _resultImageView.frame.size.width + 5;
        CGFloat fY = _resultImageView.frame.origin.y;
        CGFloat fWidth = self.frame.size.width * PERCENTAGE_WIDTH_SLOTAREA - fX;
        CGFloat fHeight = _resultImageView.frame.size.height;
        // the label
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(fX, fY, fWidth, fHeight)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:12];
        _nameLabel.textColor = [UIColor yellowColor];
        [self addSubview:_nameLabel];
    }
    [_nameLabel setHidden:NO];
    _nameLabel.text = [NSString stringWithFormat:@"%s", ITEM_NAME[_result]];
    ///*** END OF NAME ***///
    ///*** DESCRIPTION ***///
    if (!_descriptionTextView)
    {
        // the frame
        CGFloat fX = _resultImageView.frame.origin.x;
        CGFloat fY = _resultImageView.frame.origin.y + _resultImageView.frame.size.height + 5;
        CGFloat fWidth = self.frame.size.width * PERCENTAGE_WIDTH_SLOTAREA;
        CGFloat fHeight = self.frame.size.height - _resultImageView.frame.size.height - 5;
        // the text view
        _descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(fX, fY, fWidth, fHeight)];
        _descriptionTextView.backgroundColor = [UIColor clearColor];
        _descriptionTextView.editable = NO;
        _descriptionTextView.scrollEnabled = YES;
        _descriptionTextView.textColor = [UIColor whiteColor];
        [self addSubview:_descriptionTextView];
    }
    [_descriptionTextView setHidden:NO];
    _descriptionTextView.text = [NSString stringWithFormat:@"%s", ITEM_DESCRIPTION[_result]];
    ///*** END OF DESCRIPTION ***///
}

// delegates
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // to move out the particle layer
    _emitterLayer.emitterPosition = CGPointMake(-100, 0);
    // to delay the removel of the layer
    [NSTimer scheduledTimerWithTimeInterval:3
                                     target:self
                                   selector:@selector(particlesShouldBeRemoved)
                                   userInfo:nil
                                    repeats:NO];
}
@end
