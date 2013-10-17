//
//  TitleView.h
//  WordGame
//
//  Created by Brendan Dickinson on 11/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimerDelegate <NSObject>

@required
- (void)timerDidFinish;

@end

@interface TitleView : UIView

///*** PRIVATE ***///
@property (strong, nonatomic) UILabel* lblWord;
@property (strong, nonatomic) UILabel* lblNum; // the number of found words
@property (strong, nonatomic) UILabel* lblTimer;

@property NSUInteger nNumHits; // the number of words found
@property NSUInteger nTime;
@property (strong, nonatomic) NSTimer* timer;
@property (strong, nonatomic) id<TimerDelegate> delegate;
///*** END OF PRIVATE ***///

- (void)addLetter:(NSString*)letter;
- (NSString*)getLetters;
- (void)clearLetters;
- (void)incrementHits;
- (NSUInteger)getHits;

///*** PRIVATE ***///
// init
- (void)initWordLabel;
- (void)initNumLabel;
- (void)initTimerLabel;
// timer
- (void)timerDidTick;
///*** END OF PRIVATE ***///

@end
