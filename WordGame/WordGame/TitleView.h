//
//  TitleView.h
//  WordGame
//
//  Created by Brendan Dickinson on 11/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

static const int TIME = 50;
static const float TIME_FLASH = .5; // the time of one flash when the timer stops

@protocol TitleViewDelegate <NSObject>

@required
- (void)timerDidFinish;
- (void)titleViewWasTapped;
- (void)titleViewWasSwipedOver;

@end

@interface TitleView : UIView

///*** PRIVATE ***///
@property (strong, nonatomic) UILabel* wordLabel;
@property (strong, nonatomic) UILabel* numberLabel; // the number of found words
@property (strong, nonatomic) UILabel* timerLabel;

@property NSUInteger time;
@property NSUInteger ticks; // ticks to flash the timer when the timer stops
@property (strong, nonatomic) NSTimer* timer;
@property (weak, nonatomic) id<TitleViewDelegate> delegate;
///*** END OF PRIVATE ***///

@property NSUInteger numberOfHits; // the number of words found

- (void)startTimer;
- (void)stopTimerFor:(NSTimeInterval)time;
- (void)addLetter:(NSString*)letter;
- (NSString*)getLetters;
- (void)clearLetters;
- (void)incrementHits;
- (void)restart; // when the user wants to play another game
- (void)stop; // when the user quits the game

///*** PRIVATE ***///
// init
- (void)initWordLabel;
- (void)initNumLabel;
- (void)initTimerLabel;
// timer
- (void)timerDidTick;
- (void)timerWasStopped:(NSTimer*)timer;
// tap event
- (void)viewWasTapped; // used to reset the selected bricks
- (void)viewWasSwipedOver; // used to show the usable items
///*** END OF PRIVATE ***///

@end
