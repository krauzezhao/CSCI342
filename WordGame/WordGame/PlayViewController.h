//
//  PlayViewController.h
//  WordGame
//
//  Created by Hong Zhao on 3/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <math.h>
#import "AppDelegate.h"
#import "Constants.h"
#import "ItemDropModel.h"
#import "Library.h"
#import "NDTrie.h"
#import "TitleView.h"
#import "Player.h"
#import "PlayView.h"
#import "UsableItemView.h"
#import "Word.h"

static const int SPEED_DROPPEDITEM = 300;
static const float SPEED_ROTATION = M_PI_4; // 90 degrees per tick
static const int NUM_ROTATIONS = 100; // 100 rotations at 360 degrees/sec

@protocol PlayViewControllerDelegate <NSObject>

@required
// when the play view is popped out of the navigation stack
- (void)playViewWasPoppedUp;

@end

@interface PlayViewController : UIViewController <PlayViewDelegate,
                                                  TitleViewDelegate,
                                                  UsableItemViewDelegate,
                                                  UIAlertViewDelegate>

@property Level level;
@property (strong, nonatomic) NSManagedObjectContext* moc;
@property (strong, nonatomic) Library* lib;
@property (strong, nonatomic) Player* player;
// to hold the player items
// _player.items cannot be directly updated
@property (strong, nonatomic) NSMutableArray* items;
@property NDMutableTrie* trie;
@property (weak, nonatomic) id<PlayViewControllerDelegate> delegate;
// to hold the selected bricks' indices
@property (strong, nonatomic) NSMutableArray* bricks;
// image views of dropped items
@property (strong, nonatomic) NSMutableArray* droppedItems;
// tick counts of rotation animation
@property (strong, nonatomic) NSMutableArray* tickCounts;
// rotation animation timers
@property (strong, nonatomic) NSMutableArray* timers;
// the usable item view
@property (strong, nonatomic) UsableItemView* vUsableItems;

@property (weak, nonatomic) IBOutlet PlayView *vPlay;
@property (weak, nonatomic) IBOutlet TitleView *tvTitle;

// to animate a drop
- (void)animateDrop:(ItemIndex)item;
// events
- (void)itemWasDropped:(ItemIndex)item;
- (void)itemShouldRotate:(NSTimer*)timer;

@end
