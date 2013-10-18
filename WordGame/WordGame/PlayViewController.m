//
//  PlayViewController.m
//  WordGame
//
//  Created by Hong Zhao on 3/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

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
    _vPlay.delegate = self;
    _tvTitle.delegate = self;
    // the db context
    _moc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSArray* words = [_lib.fkLibWords allObjects];
    [_vPlay setLevel:_level words:words];
    // the word trie
    _trie = [[NDMutableTrie alloc] initWithCaseInsensitive:YES];
    for (Word* word in words)
        [_trie addString:word.word];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_tvTitle stop];
    // to update the database
    NSError* err = nil;
    BOOL bSucc = [_moc save:&err];
    if (err || !bSucc)
    {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Data Updating Error"
                                                     message:nil
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// delegate
- (void)letterWasSelected:(NSString*)letter
{
    [_tvTitle addLetter:letter];
    NSString* strWord = [[_tvTitle getLetters] lowercaseString];
    BOOL bFound = [_trie containsObjectForKeyWithPrefix:strWord];
    if (bFound)
    {
        // to update the view
        [_vPlay reshuffle];
        [_tvTitle clearLetters];
        [_tvTitle incrementHits];
        // to update the hits of the word
        for (Word* word in _lib.fkLibWords)
            if ([word.word isEqualToString:strWord])
                word.hits = [NSNumber numberWithInt:[word.hits intValue] + 1];
                // Database is updated when the view disappears;
    }
}

- (void)timerDidFinish
{
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Time's Up"
                                                 message:@"Would you like to play another game?"
                                                delegate:self
                                       cancelButtonTitle:@"No"
                                       otherButtonTitles:@"Yes", nil];
    [av show];
    // to update the usage of the current library
    _lib.usage = [NSNumber numberWithInt:[_lib.usage intValue] + 1];
    NSError* err = nil;
    BOOL bSucc = [_moc save:&err];
    if (!bSucc || err)
    {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Data Updating Error"
                                                     message:nil
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }
}

- (void)titleViewWasTapped
{
    [_vPlay reset];
    [_tvTitle clearLetters];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) // No button is tapped
        [self.navigationController popToRootViewControllerAnimated:YES];
    else // Yes button is tapped
    {
        [_vPlay reshuffle];
        [_tvTitle restart];
    }
}

@end
