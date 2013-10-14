//
//  BuildTableViewController.h
//  WordGame
//
//  Created by Brendan Dickinson on 14/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "BuildCell.h"
#import "WordViewController.h"
///*** PERSISTENCE ENTITIES ***///
#import "Library.h"
///*** END OF ENTITIES ***///

@interface BuildTableViewController : UITableViewController <BuildCellDelegate>

@property (strong, nonatomic) NSManagedObjectContext* moc;
@property (strong, nonatomic) NSString* strWord;

///*** PERSISTENCE ENTITIES ***///
@property Library* lib;
///*** END OF ENTITIES ***///

@end
