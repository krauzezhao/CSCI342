//
//  PlayView.m
//  WordGame
//
//  Created by Hong Zhao on 3/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "PlayView.h"

@implementation PlayView

// init from storyboard
- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
    }
    return self;
}

- (void)setLevel:(Level)level words:(NSArray *)words
{
    // all the words
    _words = words;
    // to set the level
    _level = level;
    _nDim = DIM[level];
    [self initLetters];
    [self layoutBricks];
}

- (void)reshuffle
{
    [self initLetters];
    for (UIImageView* vBrick in _maBrick)
    {
        [UIImageView animateWithDuration:.3
                              animations:^{
                                  CGFloat fX = vBrick.frame.origin.x;
                                  CGFloat fWidth = vBrick.frame.size.width;
                                  vBrick.frame = CGRectMake(fX + fWidth * .45,
                                                            vBrick.frame.origin.y,
                                                            fWidth * .1,
                                                            vBrick.frame.size.height);
                              }
                              completion:^(BOOL finished){
                                  vBrick.image =
                                  [UIImage imageNamed:
                                   [NSString stringWithFormat:@"%s_%@.ico", LETTER[LI_BLUE], _maLetters[vBrick.tag]]];
                              }];
        [UIImageView animateWithDuration:.3
                              animations:^{
                                  CGFloat fX = vBrick.frame.origin.x;
                                  CGFloat fWidth = vBrick.frame.size.width;
                                  vBrick.frame = CGRectMake(fX - fWidth * 4.5,
                                                            vBrick.frame.origin.y,
                                                            fWidth * 10,
                                                            vBrick.frame.size.height);
                              }
                              completion:nil];
    }
}

- (void)reset
{
    for (UIImageView* vBrick in _selectedLetters)
    {
        [UIImageView animateWithDuration:.2
                              animations:^{
                                  CGFloat fX = vBrick.frame.origin.x;
                                  CGFloat fY = vBrick.frame.origin.y;
                                  CGFloat fWidth = vBrick.frame.size.width;
                                  CGFloat fHeight = vBrick.frame.size.height;
                                  vBrick.frame = CGRectMake(fX + fWidth * .45,
                                                            fY + fHeight * .45,
                                                            fWidth * .1,
                                                            fHeight * .1);
                              }
                              completion:^(BOOL finished){
                                  vBrick.image =
                                  [UIImage imageNamed:
                                   [NSString stringWithFormat:@"%s_%@.ico", LETTER[LI_BLUE], _maLetters[vBrick.tag]]];
                              }];
        [UIImageView animateWithDuration:.2
                              animations:^{
                                  CGFloat fX = vBrick.frame.origin.x;
                                  CGFloat fY = vBrick.frame.origin.y;
                                  CGFloat fWidth = vBrick.frame.size.width;
                                  CGFloat fHeight = vBrick.frame.size.height;
                                  vBrick.frame = CGRectMake(fX - fWidth * 4.5,
                                                            fY - fHeight * 4.5,
                                                            fWidth * 10,
                                                            fHeight * 10);
                              }
                              completion:nil];
    }
    [_selectedLetters removeAllObjects];
}

- (CGRect)getFrameOfBrick:(int)index
{
    // invalid index
    if (index < 0 || index >= _maBrick.count)
        return CGRectMake(0, 0, 0, 0);
    // to return the frame
    UIImageView* ivBrick = [_maBrick objectAtIndex:index];
    return ivBrick.frame;
    for (UIImageView* iv in _maBrick)
        NSLog(@"%f", iv.frame.origin.x);
}

///*** PRIVATE ***///
- (void)initLetters
{
    // to initialise the letter array
    _maLetters = [[NSMutableArray alloc] init];
    _selectedLetters = [[NSMutableArray alloc] init];
    _word = [[NSMutableArray alloc] init];
    // to pick up one random word from the library
    // so that at least one word is presented
    Word* word = [_words objectAtIndex:rand() % _words.count];
    // to add its letters to the letter array
    NSString* strWord = [word.word uppercaseString];
    for (int i = 0; i < strWord.length; i++)
    {
        NSString* strLetter = [NSString stringWithFormat:@"%c", [strWord characterAtIndex:i]];
        [_maLetters addObject:strLetter];
        [_word addObject:[NSNumber numberWithInt:i]];
    }
    // to add the other letters randomly
    srand(time(NULL));
    int nNumLetters = _nDim * _nDim;
    for (int i = _maLetters.count - 1; i < nNumLetters; i++)
    {
        char letter = rand() % ('Z' + 1 - 'A') + 'A';
        NSString* strLetter = [NSString stringWithFormat:@"%c", letter];
        [_maLetters addObject:strLetter];
    }
    // to permute the letter array
    for (int i = 0; i < NUM_SWAPS[_level]; i++)
    {
        int nIndex1 = rand() % _maLetters.count;
        int nIndex2 = rand() % _maLetters.count;
        [_maLetters exchangeObjectAtIndex:nIndex1 withObjectAtIndex:nIndex2];
        // to track the word
        int nIndex1InWord = -1; // the index of nIndex1 in _word
        int nIndex2InWord = -1;
        for (int i = 0; i < _word.count; i++)
        {
            int nIndex = [[_word objectAtIndex:i] intValue];
            if (nIndex == nIndex1)
                nIndex1InWord = i;
            else if (nIndex == nIndex2)
                nIndex2InWord = i;
        }
        if (nIndex1InWord != -1 && nIndex2InWord == -1)
            [_word replaceObjectAtIndex:nIndex1InWord withObject:[NSNumber numberWithInt:nIndex2]];
        else if (nIndex1InWord == -1 && nIndex2InWord != -1)
            [_word replaceObjectAtIndex:nIndex2InWord withObject:[NSNumber numberWithInt:nIndex1]];
        else if (nIndex1InWord != -1 && nIndex2InWord != -1)
            [_word exchangeObjectAtIndex:nIndex1InWord withObjectAtIndex:nIndex2InWord];
    }
}

- (void)layoutBricks
{
    int nNumBricks = _nDim * _nDim;
    _maBrick = [[NSMutableArray alloc] initWithCapacity:nNumBricks];
    // the width and height of every brick
    CGFloat fWidth = (self.frame.size.width - 2 * SPACE) * 1.0 / _nDim;
    CGFloat fHeight = (self.frame.size.height - 2 * SPACE) * 1.0 / _nDim;
    // to add bricks
    for (int i = 0; i < _nDim; i++)
        for (int j = 0; j < _nDim; j++)
        {
            UIImageView* vBrick = [[UIImageView alloc] init];
            vBrick.contentMode = UIViewContentModeScaleToFill;
            vBrick.image =
            [UIImage imageNamed:
             [NSString stringWithFormat:
              @"%s_%@.ico", LETTER[LI_BLUE],[_maLetters objectAtIndex:i * _nDim + j]]];
            vBrick.tag = i * _nDim + j;
            [vBrick setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addSubview:vBrick];
            // constraints
            NSLayoutConstraint* lc = [NSLayoutConstraint constraintWithItem:vBrick
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1
                                                                   constant:SPACE + fWidth * j];
            [self addConstraint:lc];
            lc = [NSLayoutConstraint constraintWithItem:vBrick
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1
                                               constant:SPACE + fHeight * i];
            [self addConstraint:lc];
            lc = [NSLayoutConstraint constraintWithItem:vBrick
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeWidth
                                             multiplier:1.0 / _nDim
                                               constant:-2.0 * SPACE / _nDim];
            [self addConstraint:lc];
            lc = [NSLayoutConstraint constraintWithItem:vBrick
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeHeight
                                             multiplier:1.0 / _nDim
                                               constant:-2.0 * SPACE / _nDim];
            [self addConstraint:lc];
            // to add the tap gesture recogniser
            UITapGestureRecognizer* tgr =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(letterWasSelected:)];
            [tgr setNumberOfTapsRequired:1];
            vBrick.userInteractionEnabled = YES;
            [vBrick addGestureRecognizer:tgr];
            [_maBrick addObject:vBrick];
        }
}

- (void)find
{
    [self reset];
    for (int i = 0; i < _word.count; i++)
    {
        int nIndex = [[_word objectAtIndex:i] intValue];
        NSString* strLetter = [_maLetters objectAtIndex:nIndex];
        UIImageView* iv = [_maBrick objectAtIndex:nIndex];
        CGRect rcInit = iv.frame; // the original frame
        // to contract the image view for animation
        iv.frame = CGRectMake(rcInit.origin.x + rcInit.size.width * .45,
                              rcInit.origin.y + rcInit.size.height * .45,
                              rcInit.size.width * .1,
                              rcInit.size.height * .1);
        iv.image =
            [UIImage imageNamed:[NSString stringWithFormat:@"%s_%@.ico", LETTER[LI_ORANGE], strLetter]];
        [UIImageView animateWithDuration:.2
                                   delay:.2 * i
                                 options:UIViewAnimationOptionCurveLinear
                              animations:^{
                                  iv.frame = rcInit;
                              }
                              completion:^(BOOL finished){
                                  [_delegate letterWasSelected:strLetter index:nIndex];
                              }];
    }
}

// events
- (void)letterWasSelected:(UITapGestureRecognizer *)tgr
{
    // the tapped brick
    int nIndex = -1;
    for (int i = 0; i < _maBrick.count; i++)
        if ([_maBrick objectAtIndex:i] == tgr.view)
        {
            nIndex = i;
            break;
        }
    // to change status
    UIImageView* vBrick = [_maBrick objectAtIndex:nIndex];
    [_selectedLetters addObject:[_maBrick objectAtIndex:nIndex]];
    // to change appearance
    vBrick.image = [UIImage imageNamed:
                    [NSString stringWithFormat:@"%s_%@.ico", LETTER[LI_ORANGE], _maLetters[nIndex]]];
    // to add the letter
    [_delegate letterWasSelected:_maLetters[nIndex] index:nIndex];
}
///*** END OF PRIVATE ***///

@end
