//
//  PlayView.h
//  WordGame
//
//  Created by Hong Zhao on 3/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import <stdlib.h>
#import "Constants.h"
#import "Word.h"

// the space between the play view and the border
static const int SPACE = 0;

// the level enumeration
typedef enum _Level
{
    LV_MASTER1,
    LV_MASTER2,
    LV_MASTER3
}Level;
// the number of swaps needed to permute the letter array
static const int NUM_SWAPS[] = {49, 81, 121};
// the dimension of the bricks
static const int DIM[] = {7, 9, 11};

// the letter image prefix
typedef  enum _LetterIndex{
    LI_BLACK,
    LI_BLUE,
    LI_DG,
    LI_GOLD,
    LI_GREY,
    LI_LG,
    LI_ORANGE,
    LI_PINK,
    LI_RED,
    LI_VIOLET
}LetterIndex;

__unused static const char* LETTER[] = {
    "black", "blue", "dg", "gold", "grey",
    "lg", "orange", "pink", "red", "violet"
};

// delegate when the letter is selected
@protocol PlayViewDelegate <NSObject>

@required
// letter: the letter on the brick
// index: the index of the brick
- (void)letterWasSelected:(NSString*)letter index:(int)index;

@end

@interface PlayView : UIView

@property (weak, nonatomic) id<PlayViewDelegate> delegate;
///*** PRIVATE ***///
@property Level level;
@property int nDim; // the dimension of the brick region
@property (strong, nonatomic) NSMutableArray* bricks;
@property (strong, nonatomic) NSMutableArray* letters;
@property (strong, nonatomic) NSArray* words;
@property (strong, nonatomic) NSMutableArray* selectedLetters;
@property (strong, nonatomic) NSMutableArray* word; // the word letters' indices
///*** END OF PRIVATE ***///

- (void)setLevel:(Level)level words:(NSArray*)words;
- (void)reshuffle; // every time when a word is found or the user wants to play another game
- (void)reset; // every time when the user cancels the selection
- (CGRect)getFrameOfBrick:(int)index; // to get the frame of a brick
- (void)find; // to find the word
///*** PRIVATE ***///
- (void)initLetters;
- (void)layoutBricks;
// events
- (void)letterWasSelected:(UITapGestureRecognizer*)tgr;
///*** END OF PRIVATE ***///
@end
