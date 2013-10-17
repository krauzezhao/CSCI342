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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// delegate
- (void)letterWasSelected:(NSString*)letter
{
    [_tvTitle addLetter:letter];
    BOOL bFound = [_trie containsObjectForKeyWithPrefix:[_tvTitle getLetters]];
    if (bFound)
    {
        [_vPlay reshuffle];
        [_tvTitle clearLetters];
        [_tvTitle incrementHits];
    }
}

- (void)timerDidFinish
{
    NSLog(@"dd");
}

@end
