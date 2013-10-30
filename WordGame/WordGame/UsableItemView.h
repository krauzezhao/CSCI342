//
//  UsableItemView.h
//  WordGame
//
//  Created by Brendan Dickinson on 22/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Item.h"

static const float PERCENTAGE_ITEM_UNIT = .5;
static const int NUM_BORDER_FLASH = 4;

@protocol UsableItemViewDelegate <NSObject>

@required
- (void)usableItemViewWasSwipedOver;
- (void)usableItemWasSelected:(ItemIndex)item;

@end

@interface UsableItemView : UIView

///*** PRIVATE ***///
@property (strong, nonatomic) NSMutableArray* itemViews; // image views to hold item image
@property (strong, nonatomic) NSMutableArray* numberLabels; // labels to show the number of items
@property (strong, nonatomic) NSTimer* timer; // the timer to do the border animation
@property int ticks; // a counter to record the number of timer invocation
///*** END OF PRIVATE ***///

@property (weak, nonatomic) id<UsableItemViewDelegate> delegate;

// init
- (void)initItems:(NSMutableArray*)numOfItems;

///*** PRIVATE ***///
// events
- (void)viewWasSwipedOver;
- (void)itemWasTapped:(UITapGestureRecognizer*)tgr;
- (void)itemShouldBeHighlighted:(NSTimer*)timer;
///*** END OF PRIVATE ***///
@end
