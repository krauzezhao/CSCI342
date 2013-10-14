//
//  TitleView.h
//  WordGame
//
//  Created by Brendan Dickinson on 11/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleView : UIView

@property (strong, nonatomic) UILabel* lblWord;
@property (strong, nonatomic) UILabel* lblNum; // the number of found words
@property (strong, nonatomic) UILabel* lblTimer;

- (void)addLetter:(NSString*)letter;

///*** INIT ***///
- (void)initWordLabel;
- (void)initNumLabel;
- (void)initTimerLabel;
///*** END OF INIT ***///

@end
