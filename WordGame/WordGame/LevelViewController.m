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
        _numExp = _player.experience; // deep copy
        [_ebExpBar setLevel:[_player.level intValue] exp:[_numExp intValue]];
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
        _lblMsg.text = [NSString stringWithFormat:@"Current Library: %@", _lib.name];
        // to enable the buttons
        for (UIButton* btn in _btnLevel)
            [btn setEnabled:YES];
    }
    else
        _lblMsg.text = @"No Library Selected.";
    ///*** END OF LIBRARY ***///
//    ///*** TO FETCH THE PLAYER ***///
//    fr = [[NSFetchRequest alloc] init];
//    ed = [NSEntityDescription entityForName:@"Player"
//                     inManagedObjectContext:_moc];
//    [fr setEntity:ed];
//    err = nil;
//    NSMutableArray* mutableResults = [[_moc executeFetchRequest:fr error:&err] mutableCopy];
//    if (err || mutableResults.count == 0)
//    {
//        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Player Error"
//                                                     message:nil
//                                                    delegate:nil
//                                           cancelButtonTitle:@"OK"
//                                           otherButtonTitles:nil];
//        [av show];
//    } else
//    {
//        _player = [mutableResults objectAtIndex:0];
//        NSLog(@"1");
//        [_ebExpBar setLevel:[_player.level intValue] exp:[_player.experience intValue]];
//        NSLog(@"2");
//    }
//    ///*** END OF PLAYER ***///
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// events
- (IBAction)levelWasSelected:(id)sender
{
    // to check if a library is selected
//    LibraryTableViewController* ltvc =
//    [self.tabBarController.childViewControllers objectAtIndex:TAB_LIBRARY];
//    if (![ltvc getSelectedLibrary])
//    {
//        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"No Library Selected"
//                                                     message:@"Tap OK to go to the Library Screen"
//                                                    delegate:nil
//                                           cancelButtonTitle:@"Cancel"
//                                           otherButtonTitles:@"OK", nil];
//        [av show];
//    } else
//    {
//        // to perform the segue
//        UIButton* btn = (UIButton*)sender;
//        switch (btn.tag)
//        {
//            case LV_MASTER1:
//                [self performSegueWithIdentifier:@"SEG_MASTER1" sender:nil];
//                break;
//            case LV_MASTER2:
//                [self performSegueWithIdentifier:@"SEG_MASTER2" sender:nil];
//                break;
//            case LV_MASTER3:
//                [self performSegueWithIdentifier:@"SEG_MASTER3" sender:nil];
//        }
//    }
}

// the segue
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    // the selected library
    PlayViewController* pvc = [segue destinationViewController];
    pvc.delegate = self;
    pvc.lib = _lib;
    pvc.player = _player;
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
    [_ebExpBar animateExp:_numExp endExp:_player.experience];
    _numExp = _player.experience;
}

@end
