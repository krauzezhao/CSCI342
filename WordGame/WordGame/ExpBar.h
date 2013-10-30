//
//  ExpBar.h
//  WordGame
//
//  Created by Brendan Dickinson on 11/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

static const int OFFSET = 3;
static const int PADDING = 5;

@interface ExpBar : UIView

///*** PRIVATE ***///
@property (strong, nonatomic) UILabel* levelLabel;
@property (strong, nonatomic) UILabel* experienceLabel;
@property (strong, nonatomic) UIProgressView* experienceProgressBar;
@property (strong, nonatomic) NSTimer* timer; // to do the experience animation
@property int level; // the level of the player
@property int currentExperience; // for animation use
///*** END OF PRIVATE ***///

- (void)setLevel:(int)level exp:(int)points;
- (void)animateExp:(NSNumber*)startExp endExp:(NSNumber*)endExp;

///*** PRIVATE ***///
// init
- (void)initLevelLabel;
- (void)initExpLabel;
- (void)initExpBar;
// experience animation
- (void)expWillIncrement:(NSTimer*)timer;
///*** END OF PRIVATE ***///

@end
