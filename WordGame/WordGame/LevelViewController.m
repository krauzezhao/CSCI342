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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// the segue
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    PlayViewController* pvc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"SEG_MASTER1"])
        pvc.level = LV_MASTER1;
    else if ([segue.identifier isEqualToString:@"SEG_MASTER2"])
        pvc.level = LV_MASTER2;
    else
        pvc.level = LV_MASTER3;
}

@end
