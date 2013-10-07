//
//  SpellsTableViewController.h
//  WordGame
//
//  Created by Hong Zhao on 7/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "AppDelegate.h"

@interface SpellsTableViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext* moc;
@property (strong, nonatomic) NSMutableArray* maSpells;

@end
