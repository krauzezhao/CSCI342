//
//  TitleView.m
//  WordGame
//
//  Created by Brendan Dickinson on 11/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "TitleView.h"

@implementation TitleView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _nNumHits = 0;
        _nTime = TIME;
        [self initWordLabel];
        [self initNumLabel];
        [self initTimerLabel];
        // the tap gesture for resetting the selected bricks
        UITapGestureRecognizer* tgr =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped)];
        tgr.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tgr];
        // to start the timer
        _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(timerDidTick)
                                                userInfo:nil
                                                 repeats:YES];
    }
    return self;
}

- (void)addLetter:(NSString *)letter
{
    _lblWord.text = [NSString stringWithFormat:@"%@%@", _lblWord.text, letter];
}

- (NSString*)getLetters
{
    return _lblWord.text;
}

- (void)clearLetters
{
    _lblWord.text = @"";
}

- (void)incrementHits
{
    _nNumHits++;
    _lblNum.text = [NSString stringWithFormat:@"%d Found", _nNumHits];
}

- (NSUInteger)getHits
{
    return _nNumHits;
}

- (void)restart
{
    _nNumHits = 0;
    _nTime = TIME;
    // the labels
    _lblWord.text = @"";
    _lblNum.text = @"0 Found";
    _lblTimer.text = @"50 Sec";
    // to restart the timer
    // to start the timer
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(timerDidTick)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)stop
{
    [_timer invalidate];
}

///*** PRIVATE ***///
//** INIT **//
- (void)initWordLabel
{
    _lblWord = [[UILabel alloc] init];
    _lblWord.textAlignment = NSTextAlignmentCenter;
    _lblWord.backgroundColor = [UIColor clearColor];
    _lblWord.text = @"";
    _lblWord.textColor = [UIColor whiteColor];
    [_lblWord setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_lblWord];
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_lblWord
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblWord
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblWord
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:.5
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblWord
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:1
                                       constant:0];
    [self addConstraint:lc];
}

- (void)initNumLabel
{
    _lblNum = [[UILabel alloc] init];
    _lblNum.textAlignment = NSTextAlignmentCenter;
    _lblNum.backgroundColor = [UIColor clearColor];
    _lblNum.text = [NSString stringWithFormat:@"%d Found", _nNumHits];
    _lblNum.textColor = [UIColor whiteColor];
    [_lblNum setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_lblNum];
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_lblNum
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblNum
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblNum
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:.5
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblNum
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:.5
                                       constant:0];
    [self addConstraint:lc];
}

- (void)initTimerLabel
{
    _lblTimer = [[UILabel alloc] init];
    _lblTimer.textAlignment = NSTextAlignmentCenter;
    _lblTimer.backgroundColor = [UIColor clearColor];
    _lblTimer.text = [NSString stringWithFormat:@"%d Sec", _nTime];
    _lblTimer.textColor = [UIColor whiteColor];
    [_lblTimer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_lblTimer];
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_lblTimer
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblTimer
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblTimer
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:.5
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblTimer
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:.5
                                       constant:0];
    [self addConstraint:lc];
}
//** END OF INIT **//
- (void)timerDidTick
{
    _nTime--;
    _lblTimer.text = [NSString stringWithFormat:@"%d Sec", _nTime];
    if (_nTime == 0)
    {
        [_timer invalidate];
        [_delegate timerDidFinish];
    }
}

- (void)viewWasTapped
{
    [_delegate viewWasTapped];
}

// The timer should stop when the view disappears
//- (void)viewDidDisappear
///*** END OF PRIVATE ***///

@end
