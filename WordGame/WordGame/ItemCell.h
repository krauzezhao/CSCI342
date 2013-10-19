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
static const int BORDER_WIDTH = 10;
static const float PERCENTAGE_HEIGHT_LABEL = .3;
static const int PADDING_IMAGE = 5;
static const double TIME_RETURN = .6; // the time the item needs to return when dropped

@protocol ItemCellDelegate <NSObject>

@required
- (void)itemIsBeingDragged:(UIPanGestureRecognizer*)pgr
                    center:(CGPoint)center
                       ref:(CGPoint)ref
                     image:(NSString*)image;

@end

@interface ItemCell : UIView

///*** PRIVATE ***///
@property (strong, nonatomic) UIView* vContent;
@property (strong, nonatomic) UIView* vBorderNorth;
@property (strong, nonatomic) UIView* vBorderSouth;
@property (strong, nonatomic) UIView* vBorderWest;
@property (strong, nonatomic) UIView* vBorderEast;
@property (strong, nonatomic) UIImageView* ivItem;
@property (strong, nonatomic) UILabel* lblNum;

@property (strong, nonatomic) id<ItemCellDelegate> delegate;
@property (strong, nonatomic) NSTimer* timer; // to show the item upon dropping
@property (strong, nonatomic) NSString* strImage;
///*** END OF PRIVATE ***///

- (void)setImage:(NSString*)image;

///*** PRIVATE ***///
// init
- (void)initContentView;
- (void)initBorders;
- (void)initLabel;
- (void)initItem;
// to check if the image can be dragged
// Unknown and unavailable items cannot be dragged
- (BOOL)isDraggable:(NSString*)image;
// events
- (void)itemIsBeingDraged:(UIPanGestureRecognizer*)tgr;
- (void)itemShouldAppear;
///*** END OF PRIVATE ***///

@end
