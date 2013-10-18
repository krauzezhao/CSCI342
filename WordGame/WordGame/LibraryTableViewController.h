//
//  LibraryTableViewController.h
//  WordGame
//
//  Created by Hong Zhao on 7/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Library.h"

@interface LibraryTableViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext* moc;
@property (strong, nonatomic) NSMutableArray* libs;

@end
