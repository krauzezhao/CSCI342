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
    LibraryTableViewController* ltvc =
    [self.tabBarController.childViewControllers objectAtIndex:TAB_LIBRARY];
    pvc.lib = [ltvc getSelectedLibrary];
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

@end
