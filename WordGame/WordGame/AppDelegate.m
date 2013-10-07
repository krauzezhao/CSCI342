//
//  AppDelegate.m
//  WordGame
//
//  Created by Hong Zhao on 2/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // to avoid losses of any unsaved data
    NSError* err = nil;
    if (_moc)
        if ([_moc hasChanges] && ![_moc save:&err])
        {
            NSLog(@"Error: %@, %@", err, err.userInfo);
            abort();
        }
}

///*** CORE DATA SUPPORT ***///
// model init
- (NSManagedObjectModel*)managedObjectModel
{
    if (_mom)
        return _mom;
    _mom = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _mom;
}

// context init
- (NSManagedObjectContext*)managedObjectContext
{
    if (_moc)
        return _moc;
    NSPersistentStoreCoordinator* psc = [self persistentStoreCoordinator];
    if (psc)
    {
        _moc = [[NSManagedObjectContext alloc] init];
        [_moc setPersistentStoreCoordinator:psc];
    }
    return _moc;
}

// persistence init
- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    if (_psc)
        return _psc;
    // the database path
    NSURL* urlPath = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"TripModel.db"]];
    _psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSError* err = nil;
    if (![_psc addPersistentStoreWithType:NSSQLiteStoreType
                            configuration:nil
                                      URL:urlPath
                                  options:nil
                                    error:&err])
        NSLog(@"Error: %@, %@", err, err.userInfo);
    return _psc;
}
///*** END OF CORE DATA ***///

@end
