//
//  PlayView.h
//  WordGame
//
//  Created by Hong Zhao on 3/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <stdlib.h>
#import "Constants.h"

@interface PlayView : UIView

@property int nDim; // the dimension of the brick region

@property (strong, nonatomic) NSMutableArray* maBrick;
@property (strong, nonatomic) NSMutableArray* maLetters;

- (void)setLevel:(Level)level;

///*** PRIVATE ***///
- (void)layoutBricks;
- (void)handlePanGesture:(UIPanGestureRecognizer*)recogniser;
- (void)handleTap:(UITapGestureRecognizer*)tgr;
- (NSRange)getDraggedRange:(UIView*)view direction:(Direction)direction;
- (void)initLetters;
///*** END OF PRIVATE ***///
@end
