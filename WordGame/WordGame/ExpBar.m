//
//  ExpBar.m
//  WordGame
//
//  Created by Brendan Dickinson on 11/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "ExpBar.h"

@implementation ExpBar

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initLevelLabel];
        [self initExpLabel];
        [self initExpBar];
        // variables
        _nLevel = 0;
        _nCurExp = 0;
    }
    return self;
}

- (void)setLevel:(int)level exp:(int)points
{
    _nLevel = level;
    _lblLevel.text = [NSString stringWithFormat:@"Lv. %d", level];
    if (level != MAX_LEVEL)
    {
        _lblExpPoints.text = [NSString stringWithFormat:@"%d/%d", points, LEVEL_THRESHOLD[level]];
        _pvExp.progress = points * 1.0 / LEVEL_THRESHOLD[level];
    } else
    {
        _lblExpPoints.text = @"Max Level";
        _pvExp.progress = 1.0;
    }
}

- (void)animateExp:(NSNumber*)startExp endExp:(NSNumber*)endExp
{
    if (_timer)
        [_timer invalidate];
    // the timer parameters
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:
                           startExp, @"START",
                           endExp, @"END", nil];
    _nCurExp = [startExp intValue];
    double interval = 1.0 / ([endExp intValue] - [startExp intValue]);
    // the timer
    _timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                              target:self
                                            selector:@selector(expWillIncrement:)
                                            userInfo:param
                                             repeats:YES];
}

///*** PRIVATE ***///
//** INIT **//
- (void)initLevelLabel
{
    _lblLevel = [[UILabel alloc] init];
    _lblLevel.backgroundColor = [UIColor clearColor];
    _lblLevel.font = [UIFont boldSystemFontOfSize:18];
    _lblLevel.textColor = [UIColor whiteColor];
    [_lblLevel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_lblLevel];
    // constraints
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_lblLevel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:PADDING * 2 + OFFSET];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblLevel
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:PADDING];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblLevel
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:.5
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblLevel
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:.5
                                       constant:0];
    [self addConstraint:lc];
}

- (void)initExpLabel
{
    _lblExpPoints = [[UILabel alloc] init];
    _lblExpPoints.backgroundColor = [UIColor clearColor];
    _lblExpPoints.font = [UIFont boldSystemFontOfSize:18];
    _lblExpPoints.textAlignment = NSTextAlignmentRight;
    _lblExpPoints.textColor = [UIColor whiteColor];
    [_lblExpPoints setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_lblExpPoints];
    // constraints
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_lblExpPoints
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0 - PADDING * 2 - OFFSET];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblExpPoints
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:PADDING];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblExpPoints
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:.5
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_lblExpPoints
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:.5
                                       constant:0];
    [self addConstraint:lc];
}

- (void)initExpBar
{

    _pvExp = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [_pvExp setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_pvExp];
    // constraint
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_pvExp
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:PADDING * 2];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_pvExp
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:0 - PADDING];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_pvExp
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1
                                       constant:0 - PADDING * 2];
    [self addConstraint:lc];
}
//** END OF INIT **//
// the animation
- (void)expWillIncrement:(NSTimer*)timer
{
    NSDictionary* param = timer.userInfo;
    int nStart = [[param objectForKey:@"START"] intValue];
    int nEnd = [[param objectForKey:@"END"] intValue];
    if (nStart <= _nCurExp && _nCurExp < nEnd)
    {
        _nCurExp++;
        if (_nCurExp == LEVEL_THRESHOLD[MAX_LEVEL - 1])
        {
            _nLevel = MAX_LEVEL;
            [self setLevel:_nLevel exp:_nCurExp];
            [_timer invalidate];
            return;
        } else if (_nCurExp == LEVEL_THRESHOLD[_nLevel] + 1)
        {
            _nLevel++;
            [self setLevel:_nLevel exp:_nCurExp];
            [self animateExp:[NSNumber numberWithInt:_nCurExp] endExp:[param objectForKey:@"END"]];
            return;
        }
        [self setLevel:_nLevel exp:_nCurExp];
    } else if (_nCurExp == nEnd)
        [_timer invalidate];
}
///*** END OF PRIVATE ***///

@end
