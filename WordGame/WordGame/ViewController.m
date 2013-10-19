//
//  ViewController.m
//  WordGame
//
//  Created by Hong Zhao on 2/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // the db context
    _moc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    // the player
    NSFetchRequest* fr = [[NSFetchRequest alloc] init];
    NSEntityDescription* ed = [NSEntityDescription entityForName:@"Player"
                                          inManagedObjectContext:_moc];
    [fr setEntity:ed];
    NSError* err = nil;
    NSArray* results = [_moc executeFetchRequest:fr error:&err];
    if (err)
    {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Data Error"
                                                     message:@"Player Reading Error"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }
    // If no player is found, a new one is created.
    if (results.count == 0)
    {
        _player = [NSEntityDescription insertNewObjectForEntityForName:@"Player"
                                                inManagedObjectContext:_moc];
        _player.experience = [NSNumber numberWithInt:0];
        _player.level = [NSNumber numberWithInt:1];
        // to initialise items to unknown
        // becaue the user has not found any items
        _player.items = [[NSMutableArray alloc] init];
        for (int i = 0; i < NUM_ITEMS + NUM_SCROLLS; i++)
            [_player.items addObject:[NSNumber numberWithInt:II_UNKNOWN]];
        // to save the player
        NSError* err = nil;
        BOOL bSucc = [_moc save:&err];
        if (err || !bSucc)
        {
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Data Error"
                                                         message:nil
                                                        delegate:nil
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:nil];
            [av show];
            return;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
