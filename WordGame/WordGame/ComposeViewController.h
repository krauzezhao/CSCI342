//
//  ComposeViewController.h
//  WordGame
//
//  Created by Brendan Dickinson on 18/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "Item.h"
#import "ItemCell.h"
#import "ItemDescriptionView.h"
#import "ComposeCollectionView.h"
#import "ComposeView.h"
#import "Player.h"

static const float PERCENTAGE_WIDTH_DESCRIPTIONVIEW = .6;
static const float PERCENTAGE_HEIGHT_DESCRIPTIONVIEW = .4;

@interface ComposeViewController : UIViewController <ComposeCollectionViewDelegate,
                                                     ItemCellDelegate,
                                                     ComposeViewDelegate,
                                                     UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet ComposeView *composeView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet ComposeCollectionView *itemsView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) UIImageView* draggedItemView;
@property (strong, nonatomic) ItemDescriptionView* itemDescriptionView;
@property CGPoint initialPoint; // the originial coordinate of any item
//@property CGPoint ptInitialScroll; // the original coordinate of the scroll
@property CGSize itemSize; // the size of the dragged item
@property BOOL isInCompositionArea; // whether the drop is in the composition area
@property BOOL isOK; // whether the user taps OK
@property (strong, nonatomic) NSTimer* timer; // the timer to fade out the item description

@property (strong, nonatomic) NSManagedObjectContext* moc;
@property (strong, nonatomic) Player* player;
@property (weak, nonatomic) NSMutableArray* items; // the player's items

// to move back the dragged item
- (void)moveBackItem:(CGPoint)ptInitial;
// to fade in the message label
- (void)showMessage;
// events
// to fade out the item description
- (void)itemDescriptionShouldFadeOut;

@end
