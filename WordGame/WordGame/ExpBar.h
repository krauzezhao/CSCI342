//
//  ExpBar.h
//  WordGame
//
//  Created by Brendan Dickinson on 11/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpBar : UIView

@property (strong, nonatomic) UILabel* lblLevel;
@property (strong, nonatomic) UILabel* lblExpPoints;
@property (strong, nonatomic) UIProgressView* pvExp;

///*** INIT ***///
- (void)initLevelLabel;
- (void)initExpLabel;
- (void)initExpBar;
///*** END OF INIT ***///

@end
