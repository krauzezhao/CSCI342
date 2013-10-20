//
//  PlayViewController.h
//  WordGame
//
//  Created by Hong Zhao on 3/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Constants.h"
#import "ItemDropModel.h"
#import "Library.h"
#import "NDTrie.h"
#import "TitleView.h"
#import "Player.h"
#import "PlayView.h"
#import "Word.h"

@protocol PlayViewControllerDelegate <NSObject>

@required
// when the play view is popped out of the navigation stack
- (void)playViewWasPoppedUp;

@end

@interface PlayViewController : UIViewController <PlayViewDelegate,
                                                  TitleViewDelegate,
                                                  UIAlertViewDelegate>

@property Level level;
@property (strong, nonatomic) NSManagedObjectContext* moc;
@property (strong, nonatomic) Library* lib;
@property (strong, nonatomic) Player* player;
// to hold the player items
// _player.items cannot be directly updated
@property (strong, nonatomic) NSMutableArray* items;
@property NDMutableTrie* trie;
@property (strong, nonatomic) id<PlayViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet PlayView *vPlay;
@property (weak, nonatomic) IBOutlet TitleView *tvTitle;

// events
- (void)itemWasDropped:(ItemIndex)item;

@end
