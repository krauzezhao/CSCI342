//
//  ViewController.h
//  WordGame
//
//  Created by Hong Zhao on 2/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Item.h"
#import "Player.h"

#import "ItemDropModel.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext* moc;

@end
