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
        _nTime = 50;
        [self initWordLabel];
        [self initNumLabel];
        [self initTimerLabel];
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

///*** PRIVATE ***///
//** INIT **//
- (void)initWordLabel
{
    _lblWord = [[UILabel alloc] init];
    _lblWord.textAlignment = NSTextAlignmentCenter;
    _lblWord.backgroundColor = [UIColor clearColor];
    _lblWord.text = @"";
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
///*** END OF PRIVATE ***///

@end
