//
//  LevelViewController.m
//  WordGame
//
//  Created by Hong Zhao on 3/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "LevelViewController.h"
#import "Constants.h"
#import "PlayViewController.h"

@interface LevelViewController ()

@end

@implementation LevelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // the db context
    _moc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    ///*** TO FETCH THE PLAYER ***///
    NSFetchRequest* fr = [[NSFetchRequest alloc] init];
    NSEntityDescription* ed = [NSEntityDescription entityForName:@"Player"
                     inManagedObjectContext:_moc];
    [fr setEntity:ed];
    NSError* err = nil;
    NSMutableArray* mutableResults = [[_moc executeFetchRequest:fr error:&err] mutableCopy];
    if (err || mutableResults.count == 0)
    {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Player Error"
                                                     message:nil
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    } else
    {
        _player = [mutableResults objectAtIndex:0];
        _experience = _player.experience; // deep copy
        [_experienceBar setLevel:[_player.level intValue] exp:[_experience intValue]];
    }
    ///*** END OF PLAYER ***///
}

// to retrieve the selected library
- (void)viewWillAppear:(BOOL)animated
{
    ///*** TO FETCH THE LIBRARY ***///
    NSFetchRequest* fr = [[NSFetchRequest alloc] init];
    // the entity
    NSEntityDescription* ed = [NSEntityDescription entityForName:@"Library"
                                          inManagedObjectContext:_moc];
    [fr setEntity:ed];
    // condition
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"selected = %@", [NSNumber numberWithBool:YES]];
    [fr setPredicate:pred];
    // the result
    NSError* err = nil;
    NSArray* results = [_moc executeFetchRequest:fr error:&err];
    if (err)
    {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Library Error"
                                                     message:nil
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }
    // to check if a library is selected
    if (results.count == 1)
    {
        // the message label
        _lib = [results objectAtIndex:0];
        _messageLabel.text = [NSString stringWithFormat:@"Current Library: %@", _lib.name];
        // to enable the buttons
        for (UIButton* btn in _levelButton)
            [btn setEnabled:YES];
    }
    else
        _messageLabel.text = @"No Library Selected.";
    ///*** END OF LIBRARY ***///
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// the segue
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    // the selected library
    PlayViewController* pvc = [segue destinationViewController];
    pvc.delegate = self;
    pvc.lib = _lib;
    // the segue
    if ([segue.identifier isEqualToString:@"SEG_MASTER1"])
    {
        pvc.level = LV_MASTER1;
        pvc.navigationItem.title = @"Master 1";
    }
    else if ([segue.identifier isEqualToString:@"SEG_MASTER2"])
    {
        pvc.level = LV_MASTER2;
        pvc.navigationItem.title = @"Master 2";
    }
    else
    {
        pvc.level = LV_MASTER3;
        pvc.navigationItem.title = @"Master 3";
    }
}

// delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) // OK is tapped
        [self.tabBarController setSelectedIndex:TAB_LIBRARY];
}

- (void)playViewWasPoppedUp
{
    [_experienceBar animateExp:_experience endExp:_player.experience];
    _experience = _player.experience;
}

@end
