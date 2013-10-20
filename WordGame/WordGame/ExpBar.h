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
@property (strong, nonatomic) UILabel* lblLevel;
@property (strong, nonatomic) UILabel* lblExpPoints;
@property (strong, nonatomic) UIProgressView* pvExp;
@property (strong, nonatomic) NSTimer* timer; // to do the experience animation
@property int nLevel; // the level of the player
@property int nCurExp; // for animation use
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
