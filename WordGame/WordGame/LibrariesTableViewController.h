//
//  LibrariesTableViewController.h
//  WordGame
//
//  Created by Brendan Dickinson on 14/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Library.h"
#import "WordsTableViewController.h"

@interface LibrariesTableViewController : UITableViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext* moc;
@property (strong, nonatomic) NSMutableArray* maLib; // the libraries

// detail button is tapped
- (void)detailWasTapped;
// navigation bar item events
- (IBAction)homeWasTapped:(id)sender;
- (IBAction)addWasTapped:(id)sender;
@end
