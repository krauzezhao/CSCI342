//
//  ComposeView.h
//  WordGame
//
//  Created by Brendan Dickinson on 20/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Item.h"

static const float PERCENTAGE_WIDTH_SLOTAREA = .7; // the slots area
static const float PERCENTAGE_WIDTH_SLOT = .7;
static const float PERCENTAGE_HEIGHT_RESULT = .6;
// the composition time
static const float TIME_COMPOSE = 3;
// the Compose and Cancel button size
static const int BUTTON_WIDTH = 70;
static const int BUTTON_HEIGHT = 30;
static const int BUTTON_OFFSET = 10; // the offset from the border

typedef enum _ItemDropStatus
{
    IDS_SUCCESS, // The item can be dropped here.
    IDS_NOSCROLL, // no scroll here
    IDS_NONSCROLL, // an item when there's no scroll
    IDS_ANOTHERSCROLL, // already a scroll
    IDS_NONFITITEM, // The item is not in the formula.
    IDS_FULL, // All needed items have been put here.
    IDS_INVALID // any other situations
}ItemDropStatus;

@protocol ComposeViewDelegate <NSObject>

@required
// center: the center of the slot area
- (void)cancelWasTapped:(ItemIndex)scroll items:(NSMutableArray*)items;
- (void)discardWasTapped:(ItemIndex)result;
- (void)okWasTapped:(ItemIndex)result;

@end

@interface ComposeView : UIView

@property (weak, nonatomic) id<ComposeViewDelegate> delegate;

///*** PRIVATE ***///
// the bottom right
@property CGPoint ptBottomRight;
// the slot views
@property (strong, nonatomic) NSMutableArray* slots;
@property (strong, nonatomic) UIButton* btnCompose;
@property (strong, nonatomic) UIButton* btnCancel;
// the composition particle layer
@property (strong, nonatomic) CAEmitterLayer* el;
// the view to hold the result item
@property (strong, nonatomic) UIImageView* ivResult;
// the label to hold the name of the item
@property (strong, nonatomic) UILabel* lblName;
// the text view to hold the description of the item
@property (strong, nonatomic) UITextView* tvDescription;
///*** END OF PRIVATE ***///

// to determine whether a scroll has been put here
@property BOOL bHasScroll;
// the scroll
@property ItemIndex iiScroll;
// the result
@property ItemIndex iiResult;
// to record the dropped non-scroll items
@property (strong, nonatomic) NSMutableArray* items;

// return: whether the item can be dropped here
- (ItemDropStatus)itemWasDropped:(ItemIndex)item;
// The user confirms to discard the item.
- (void)discard;

- (void)cancelWasTapped:(id)sender;

///*** PRIVATE ***///
//** EVENTS **//
- (void)composeWasTapped:(id)sender;
// to delay the removal of the particle system after composition
- (void)particlesShouldBeRemoved;
// The composition finishes.
- (void)compositionDidFinish;
//** END OF EVENTS **//
// the cancel button when there's a scroll
- (void)showCancelButton:(NSString*)title; // cancel or discard
// the compose button where all items needed are put
- (void)showComposeButton:(NSString*)title; // compose or OK
// the particle effects
- (void)fireParticles;
// to show the item descrition
- (void)showDescription;
///*** END OF PRIVATE ***///
@end
