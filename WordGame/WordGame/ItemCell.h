//
//  ItemCell.h
//  WordGame
//
//  Created by Brendan Dickinson on 18/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

static const float PERCENTAGE_CONTENTVIEW = .8;
static const int BORDER_WIDTH = 10;
static const float PERCENTAGE_HEIGHT_LABEL = .3;
static const int PADDING_IMAGE = 5;

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
///*** END OF PRIVATE ***///

///*** PRIVATE ***///
// init
- (void)initContentView;
- (void)initBorders;
- (void)initLabel;
- (void)initItem;
// events
- (void)itemIsBeingDraged:(UIPanGestureRecognizer*)tgr;
///*** END OF PRIVATE ***///

@end
