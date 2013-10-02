//
//  PlayView.h
//  WordGame
//
//  Created by Hong Zhao on 3/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

#define SPACE 20

@interface PlayView : UIView

@property int nDim; // the dimension of the brick region

@property (strong, nonatomic) NSMutableArray* maBrick;

- (void)setLevel:(enum Level)level;

///*** PRIVATE ***///
- (void)layoutBricks;
///*** END OF PRIVATE ***///
@end
