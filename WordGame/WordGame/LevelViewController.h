//
//  LevelViewController.h
//  WordGame
//
//  Created by Hong Zhao on 3/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h";
#import "Library.h"
#import "LibraryTableViewController.h"

static const int TAB_LIBRARY = 1;

@interface LevelViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext* moc;
@property (strong, nonatomic) Library* lib;

- (IBAction)levelWasSelected:(id)sender;

@end
