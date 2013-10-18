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
#import "Library.h"

static const int TAB_LIBRARY = 1;

@interface LevelViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext* moc;
@property (strong, nonatomic) Library* lib;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnLevel;
@property (weak, nonatomic) IBOutlet UILabel *lblMsg;

- (IBAction)levelWasSelected:(id)sender;

@end
