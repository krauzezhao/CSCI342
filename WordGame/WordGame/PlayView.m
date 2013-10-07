//
//  PlayView.m
//  WordGame
//
//  Created by Hong Zhao on 3/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "PlayView.h"
#import <QuartzCore/QuartzCore.h> // to access border functionality
#import <math.h> // abs()

@implementation PlayView

// init from storyboard
- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setLevel:(Level)level
{
    switch (level)
    {
        case LV_MASTER1:
            _nDim = 6;
            break;
        case LV_MASTER2:
            _nDim = 10;
            break;
        case LV_MASTER3:
            _nDim = 14;
    }
    [self layoutBricks];
}

///*** PRIVATE ***///
- (void)layoutBricks
{
    int nNumBricks = _nDim * _nDim;
    _maBrick = [[NSMutableArray alloc] initWithCapacity:nNumBricks];
    // the width and height of every brick
    CGFloat fWidth = (self.frame.size.width - 2 * SPACE) * 1.0 / _nDim;
    CGFloat fHeight = (self.frame.size.height - 2 * SPACE) * 1.0 / _nDim;
    // to add bricks
    for (int i = 0; i < _nDim; i++)
        for (int j = 0; j < _nDim; j++)
        {
            UIView* vBrick = [[UIView alloc] init];
            vBrick.backgroundColor = [UIColor redColor];
            vBrick.layer.borderColor = [UIColor blackColor].CGColor;
            vBrick.layer.borderWidth = 1;
            vBrick.tag = BS_UNSELECTED;
            [vBrick setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addSubview:vBrick];
            // constraints
            NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:vBrick
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1
                                                                   constant:SPACE + fWidth * j];
            [self addConstraint:lc];
            lc = [NSLayoutConstraint constraintWithItem:vBrick
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1
                                               constant:SPACE + fHeight * i];
            [self addConstraint:lc];
            lc = [NSLayoutConstraint constraintWithItem:vBrick
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeWidth
                                             multiplier:1.0 / _nDim
                                               constant:-2.0 * SPACE / _nDim];
            [self addConstraint:lc];
            lc = [NSLayoutConstraint constraintWithItem:vBrick
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeHeight
                                             multiplier:1.0 / _nDim
                                               constant:-2.0 * SPACE / _nDim];
            [self addConstraint:lc];
            // to add the span gesture recogniser
//            UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                                                  action:@selector(handlePanGesture:)];
//            [vBrick addGestureRecognizer:pgr];
            // to add the tap gesture recogniser
            UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(handleTap:)];
            [tgr setNumberOfTapsRequired:1];
            [vBrick addGestureRecognizer:tgr];
            // to add a label to the brick
            UILabel* label = [[UILabel alloc] init];
            label.text = [NSString stringWithFormat:@"%d", i * _nDim + j];
            [vBrick addSubview:label];
            [_maBrick addObject:vBrick];            
        }
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)recogniser
{
    // the size of the brick
    CGFloat fWidth = recogniser.view.bounds.size.width;
    CGFloat fHeight = recogniser.view.bounds.size.height;
    ///*** MOVING ***///
    CGPoint translation = [recogniser translationInView:self]; // the new location
    CGPoint velocity = [recogniser velocityInView:self]; // the velocity
    // to limit the move to horizontal and vertical
    // and the velocity is changed to the integer multiple of the width or height
    if (abs(velocity.x) > abs(velocity.y)) // horizontally
    {
        // to get the range of bricks to be moved
        NSRange range = [self getDraggedRange:recogniser.view direction:D_HORIZONTAL];
        // to compute the displacement
        int displacement = ((int)(translation.x / fWidth)) * fWidth;
        // to move the row
        for (int i = 0; i < _nDim; i++)
        {
            int index = range.location + i;
            UIView* vBrick = [_maBrick objectAtIndex:index];
            CGFloat fX = vBrick.center.x;
            //vBrick.center = CGPointMake(fX + translation.x, vBrick.center.y);
            vBrick.center = CGPointMake(fX + displacement, vBrick.center.y);
        }
    }
    else // vertically
    {
        NSRange range = [self getDraggedRange:recogniser.view direction:D_VERTICAL];
        for (int i = 0; i < _nDim; i++)
        {
            int index = i * _nDim + range.location;
            UIView* vBrick = [_maBrick objectAtIndex:index];
            vBrick.center = CGPointMake(vBrick.center.x, vBrick.center.y + translation.y);
        }
    }
    [recogniser setTranslation:CGPointMake(0, 0) inView:self];
    ///*** MOVING ***///
}

- (NSRange)getDraggedRange:(UIView *)view direction:(Direction)direction
{
    int index = 0; // the index of the brick being dragged
    for (int i = 0; i < _maBrick.count; i++)
        if ([_maBrick objectAtIndex:i] == view)
        {
            index = i;
            break;
        }
    // to get the range by direction
    NSRange range;
    range.length = _nDim;
    switch (direction)
    {
        case D_HORIZONTAL:
            // to get the first brick within the range
            range.location = (index / _nDim) * _nDim;
            break;
        case D_VERTICAL:
            range.location = index - (index / _nDim) * _nDim;
    }
    return range;
}

- (void)handleTap:(UITapGestureRecognizer*)tgr
{
    // the tapped brick
    int index = -1;
    for (int i = 0; i < _maBrick.count; i++)
        if ([_maBrick objectAtIndex:i] == tgr.view)
        {
            index = i;
            break;
        }
    // to change status
    UIView* vBrick = [_maBrick objectAtIndex:index];
    switch (vBrick.tag)
    {
        case BS_HIGHLIGHTED:
            vBrick.tag = BS_UNSELECTED;
            // to change appearance
            vBrick.backgroundColor = [UIColor redColor];
            vBrick.layer.borderColor = [UIColor blackColor].CGColor;
            vBrick.layer.borderWidth = 1;
            break;
        case BS_UNSELECTED:
            vBrick.tag = BS_HIGHLIGHTED;
            // to change appearance
            vBrick.backgroundColor = [UIColor greenColor];
            vBrick.layer.borderColor = [UIColor redColor].CGColor;
            vBrick.layer.borderWidth = 2;
    }
}
///*** END OF PRIVATE ***///

@end
