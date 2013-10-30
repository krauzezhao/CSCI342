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
        _numberOfHits = 0;
        _time = TIME;
        [self initWordLabel];
        [self initNumLabel];
        [self initTimerLabel];
        // the tap gesture for resetting the selected bricks
        UITapGestureRecognizer* tgr =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped)];
        tgr.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tgr];
        // the swipe gesture for usable items
        UISwipeGestureRecognizer* sgr =
            [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasSwipedOver)];
        sgr.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:sgr];
    }
    return self;
}

- (void)startTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(timerDidTick)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)stopTimerFor:(NSTimeInterval)time
{
    [_timer invalidate];
    _ticks = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:TIME_FLASH
                                              target:self
                                            selector:@selector(timerWasStopped:)
                                            userInfo:[NSNumber numberWithInt:time / TIME_FLASH]
                                             repeats:YES];
}

- (void)addLetter:(NSString *)letter
{
    _wordLabel.text = [NSString stringWithFormat:@"%@%@", _wordLabel.text, letter];
}

- (NSString*)getLetters
{
    return _wordLabel.text;
}

- (void)clearLetters
{
    [UILabel animateWithDuration:.5
                      animations:^{
                          _wordLabel.alpha = 0;
                      }
                      completion:^(BOOL finished){
                          _wordLabel.alpha = 1;
                          _wordLabel.text = @"";
                      }];
}

- (void)incrementHits
{
    _numberOfHits++;
    _numberLabel.text = [NSString stringWithFormat:@"%d Found", _numberOfHits];
}

- (void)restart
{
    _numberOfHits = 0;
    _time = TIME;
    // the labels
    _wordLabel.text = @"";
    _numberLabel.text = @"0 Found";
    _timerLabel.text = @"50 Sec";
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
    _wordLabel = [[UILabel alloc] init];
    _wordLabel.textAlignment = NSTextAlignmentCenter;
    _wordLabel.backgroundColor = [UIColor clearColor];
    _wordLabel.text = @"";
    _wordLabel.textColor = [UIColor whiteColor];
    [_wordLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_wordLabel];
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_wordLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_wordLabel
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_wordLabel
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:.5
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_wordLabel
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
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.backgroundColor = [UIColor clearColor];
    _numberLabel.text = [NSString stringWithFormat:@"%d Found", _numberOfHits];
    _numberLabel.textColor = [UIColor whiteColor];
    [_numberLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_numberLabel];
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_numberLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_numberLabel
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_numberLabel
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:.5
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_numberLabel
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
    _timerLabel = [[UILabel alloc] init];
    _timerLabel.textAlignment = NSTextAlignmentCenter;
    _timerLabel.backgroundColor = [UIColor clearColor];
    _timerLabel.text = [NSString stringWithFormat:@"%d Sec", _time];
    _timerLabel.textColor = [UIColor whiteColor];
    [_timerLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_timerLabel];
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_timerLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_timerLabel
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_timerLabel
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:.5
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_timerLabel
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
    _time--;
    _timerLabel.text = [NSString stringWithFormat:@"%d Sec", _time];
    if (_time == 0)
    {
        [_timer invalidate];
        [_delegate timerDidFinish];
    }
}

- (void)timerWasStopped:(NSTimer*)timer
{
    // the total time
    NSNumber* numTotalTime = (NSNumber*)timer.userInfo;
    int nTotalTime = [numTotalTime intValue];
    // to tick
    if (_ticks < nTotalTime)
    {
        if (_ticks % 2 == 0)
            _timerLabel.alpha = 0;
        else
            _timerLabel.alpha = 1;
        _ticks++;
    } else
    {
        [_timer invalidate];
        [self startTimer];
    }
}

- (void)viewWasTapped
{
    [_delegate titleViewWasTapped];
}

- (void)viewWasSwipedOver
{
    [_delegate titleViewWasSwipedOver];
}
///*** END OF PRIVATE ***///

@end
