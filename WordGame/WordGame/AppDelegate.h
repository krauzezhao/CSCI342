//
//  AppDelegate.h
//  WordGame
//
//  Created by Hong Zhao on 2/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

///*** CORE DATA SUPPORT ***///
@property (strong, nonatomic) NSManagedObjectModel* mom;
@property (strong, nonatomic) NSManagedObjectContext* moc;
@property (strong, nonatomic) NSPersistentStoreCoordinator* psc;

// initialisation
- (NSManagedObjectModel*)managedObjectModel;
- (NSManagedObjectContext*)managedObjectContext;
- (NSPersistentStoreCoordinator*)persistentStoreCoordinator;
///*** END OF CORE DATA ***///

@end
