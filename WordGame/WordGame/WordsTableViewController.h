//
//  WordsTableViewController.h
//  WordGame
//
//  Created by Brendan Dickinson on 14/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "DefinitionViewController.h"
#import "Library.h"
#import "Word.h"
#import "WordCell.h"

@interface WordsTableViewController : UITableViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext* moc;
@property (strong, nonatomic) Library* lib;
@property (strong, nonatomic) NSMutableArray* words;

// events
- (IBAction)addWasTapped:(id)sender;

@end
