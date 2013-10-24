//
//  ItemCell.h
//  WordGame
//
//  Created by Brendan Dickinson on 18/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Item.h"

static const float PERCENTAGE_CONTENTVIEW = .8;
static const float PERCENTAGE_HEIGHT_LABEL = .3;
static const int PADDING_IMAGE = 5;
static const double TIME_RETURN = .6; // the time the item needs to return when dropped

@protocol ItemCellDelegate <NSObject>

@required
- (void)itemIsBeingDragged:(UIPanGestureRecognizer*)pgr
                    center:(CGPoint)center
                       ref:(CGPoint)ref
                      item:(ItemIndex)item;

@end

@interface ItemCell : UIView

@property ItemIndex item; // the current item
///*** PRIVATE ***///
@property (strong, nonatomic) UIView* vContent;
@property (strong, nonatomic) UIImageView* ivItem;
@property (strong, nonatomic) UILabel* lblNum;

@property (weak, nonatomic) id<ItemCellDelegate> delegate;
@property (strong, nonatomic) NSTimer* timer; // to show the item upon dropping and the highlighting
@property int nTicks; // the tick for the highlighting
///*** END OF PRIVATE ***///

- (void)setItem:(ItemIndex)item number:(int)num;
- (void)highlight; // to highlight the item

///*** PRIVATE ***///
// init
- (void)initContentView;
- (void)initLabel;
- (void)initItem;
// events
- (void)itemIsBeingDragged:(UIPanGestureRecognizer*)pgr;
- (void)itemShouldAppear;
- (void)itemShouldBeHighlighted;
///*** END OF PRIVATE ***///

@end
