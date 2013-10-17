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
    switch (level)
    {
        case LV_MASTER1:
            _nDim = 7;
            break;
        case LV_MASTER2:
            _nDim = 10;
            break;
        case LV_MASTER3:
            _nDim = 12;
    }
    [self initLetters];
    [self layoutBricks];
}

- (void)reshuffle
{
    [self initLetters];
    if (_prevBricks && _prevBricks.count)
        for (UIImageView* vBrick in _prevBricks)
            [vBrick removeFromSuperview];
    for (UIImageView* vBrick in _maBrick)
    {
        [UIImageView beginAnimations:nil context:nil];
        CATransform3D t = CATransform3DRotate(vBrick.layer.transform, 1.57, 0, 1, 0);
        [UIImageView setAnimationDuration:.5];
        vBrick.layer.transform = t;
        [UIImageView commitAnimations];
    }
    _prevBricks = [NSMutableArray arrayWithArray:_maBrick];
    [self layoutBricks];
}

///*** PRIVATE ***///
- (void)initLetters
{
    // to initialise the letter array
    _maLetters = [[NSMutableArray alloc] init];
    _selectedLetters = [[NSMutableArray alloc] init];
    // to pick up one random word from the library
    // so that at least one word is presented
    Word* word = [_words objectAtIndex:rand() % _words.count];
    // to add its letters to the letter array
    NSString* strWord = [word.word uppercaseString];
    for (int i = 0; i < strWord.length; i++)
    {
        NSString* strLetter = [NSString stringWithFormat:@"%c", [strWord characterAtIndex:i]];
        [_maLetters addObject:strLetter];
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
    for (int i = 0; i < NUM_SWAPS; i++)
    {
        int nIndex1 = rand() % _maLetters.count;
        int nIndex2 = rand() % _maLetters.count;
        [_maLetters exchangeObjectAtIndex:nIndex1 withObjectAtIndex:nIndex2];
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
            vBrick.tag = LS_UNSELECTED;
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
    switch (vBrick.tag)
    {
//        case LS_SELECTED:
//            vBrick.tag = LS_UNSELECTED;
//            // to change appearance
//            vBrick.image =
//            [UIImage imageNamed:
//             [NSString stringWithFormat:@"%s_%@.ico", LETTER[LI_BLUE], _maLetters[nIndex]]];
//            // to delete the letter
//            [_delegate letterWasUnselected:_maLetters[nIndex]];
//            break;
        case LS_UNSELECTED:
            vBrick.tag = LS_SELECTED;
            // to change appearance
            vBrick.image =
            [UIImage imageNamed:
             [NSString stringWithFormat:@"%s_%@.ico", LETTER[LI_ORANGE], _maLetters[nIndex]]];
            // to add the letter
            [_delegate letterWasSelected:_maLetters[nIndex]];
    }
}
///*** END OF PRIVATE ***///

@end
