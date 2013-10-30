//
//  LevelViewController.h
//  WordGame
//
//  Created by Hong Zhao on 3/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "ExpBar.h"
#import "Library.h"
#import "Player.h"
#import "PlayViewController.h"

static const int TAB_LIBRARY = 1;

@interface LevelViewController : UIViewController <UIAlertViewDelegate,
                                                   PlayViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext* moc;
@property (strong, nonatomic) Library* lib;
@property (strong, nonatomic) Player* player;
// the experience before a game
@property (strong, nonatomic) NSNumber* experience;

@property (weak, nonatomic) IBOutlet ExpBar *experienceBar;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *levelButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end
