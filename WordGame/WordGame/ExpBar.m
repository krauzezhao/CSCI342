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
        _level = 0;
        _currentExperience = 0;
    }
    return self;
}

- (void)setLevel:(int)level exp:(int)points
{
    _level = level;
    _levelLabel.text = [NSString stringWithFormat:@"Lv. %d", level];
    if (level != MAX_LEVEL)
    {
        _experienceLabel.text = [NSString stringWithFormat:@"%d/%d", points, LEVEL_THRESHOLD[level]];
        _experienceProgressBar.progress = points * 1.0 / LEVEL_THRESHOLD[level];
    } else
    {
        _experienceLabel.text = @"Max Level";
        _experienceProgressBar.progress = 1.0;
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
    _currentExperience = [startExp intValue];
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
    _levelLabel = [[UILabel alloc] init];
    _levelLabel.backgroundColor = [UIColor clearColor];
    _levelLabel.font = [UIFont boldSystemFontOfSize:18];
    _levelLabel.textColor = [UIColor whiteColor];
    [_levelLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_levelLabel];
    // constraints
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_levelLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:PADDING * 2 + OFFSET];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_levelLabel
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:PADDING];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_levelLabel
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:.5
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_levelLabel
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
    _experienceLabel = [[UILabel alloc] init];
    _experienceLabel.backgroundColor = [UIColor clearColor];
    _experienceLabel.font = [UIFont boldSystemFontOfSize:18];
    _experienceLabel.textAlignment = NSTextAlignmentRight;
    _experienceLabel.textColor = [UIColor whiteColor];
    [_experienceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_experienceLabel];
    // constraints
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_experienceLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0 - PADDING * 2 - OFFSET];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_experienceLabel
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:PADDING];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_experienceLabel
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:.5
                                       constant:0];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_experienceLabel
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

    _experienceProgressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [_experienceProgressBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_experienceProgressBar];
    // constraint
    NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:_experienceProgressBar
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:PADDING * 2];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_experienceProgressBar
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:0 - PADDING];
    [self addConstraint:lc];
    lc = [NSLayoutConstraint constraintWithItem:_experienceProgressBar
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
    if (nStart <= _currentExperience && _currentExperience < nEnd)
    {
        _currentExperience++;
        if (_currentExperience == LEVEL_THRESHOLD[MAX_LEVEL - 1])
        {
            _level = MAX_LEVEL;
            [self setLevel:_level exp:_currentExperience];
            [_timer invalidate];
            return;
        } else if (_currentExperience == LEVEL_THRESHOLD[_level] + 1)
        {
            _level++;
            [self setLevel:_level exp:_currentExperience];
            [self animateExp:[NSNumber numberWithInt:_currentExperience] endExp:[param objectForKey:@"END"]];
            return;
        }
        [self setLevel:_level exp:_currentExperience];
    } else if (_currentExperience == nEnd)
        [_timer invalidate];
}
///*** END OF PRIVATE ***///

@end
