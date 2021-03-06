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
    _bricks = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
    _playView.delegate = self;
    _titleView.delegate = self;
    // rotation animation init
    _droppedItems = [[NSMutableArray alloc] init];
    _tickCounts = [[NSMutableArray alloc] init];
    _timers = [[NSMutableArray alloc] init];
    // the db context
    _moc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (void)viewWillAppear:(BOOL)animated
{
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
        // the items
        _items = _player.items;
    }
    ///*** END OF PLAYER ***///
}

- (void)viewDidAppear:(BOOL)animated
{
    NSArray* words = [_lib.fkLibWords allObjects];
    if (words.count == 0) // no words in the library
    {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"No Words In This Library"
                                                     message:nil
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    [_playView setLevel:_level words:words];
    [_titleView startTimer];
    // the word trie
    _trie = [[NDMutableTrie alloc] initWithCaseInsensitive:YES];
    for (Word* word in words)
        [_trie addString:word.word];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_titleView stop];
    // to update the database
    _lib.usage = [NSNumber numberWithInt:[_lib.usage intValue] + 1];
    _player.items = _items;
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

- (void)viewDidDisappear:(BOOL)animated
{
    [_delegate playViewWasPoppedUp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)animateDrop:(ItemIndex)item
{
    // to randomly pick up a brick from all selected ones
    srand(time(NULL));
    int nIndex = [[_bricks objectAtIndex:rand() % _bricks.count] intValue];
    // the frame of the brick
    CGRect rcBrick = [_playView getFrameOfBrick:nIndex];
    // to convert the frame to the current reference
    rcBrick = CGRectMake(self.view.frame.origin.x + rcBrick.origin.x,
                         _titleView.frame.size.height + rcBrick.origin.y,
                         rcBrick.size.width * 1.5,
                         rcBrick.size.width * 1.5);
    // the animated image view
    UIImageView* iv = [[UIImageView alloc] initWithFrame:rcBrick];
    iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"%s%s", PREFIX_AVAIL, ITEM[item]]];
    iv.alpha = .7;
    iv.tag = _droppedItems.count; // the index of this image view
    [self.view addSubview:iv];
    [_droppedItems addObject:iv];
    // the animation duration
    CGFloat fDistance = sqrt(pow(5 - rcBrick.origin.x, 2) + pow(5 - rcBrick.origin.y, 2));
    CGFloat fDuration = fDistance / SPEED_DROPPEDITEM;
    // the rotation
    [_tickCounts addObject:[NSNumber numberWithInt:0]];
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:fDuration / NUM_ROTATIONS * 4
                                                      target:self
                                                    selector:@selector(itemShouldRotate:)
                                                    userInfo:[NSNumber numberWithInt:iv.tag]
                                                     repeats:YES];
    [_timers addObject:timer];
    // the moving animation
    [UIImageView animateWithDuration:fDuration
                          animations:^{
                              iv.frame = CGRectMake(5, 5, 30, 30);
                              iv.alpha = 1;
                          }
                          completion:^(BOOL finished) {
                              [UIImageView animateWithDuration:1
                                                         delay:3
                                                       options:UIViewAnimationOptionCurveLinear
                                                    animations:^{
                                                        iv.alpha = 0;
                                                    }
                                                    completion:^(BOOL finished) {
                                                        [iv removeFromSuperview];
                                                    }];
                          }];
}

// events
- (void)itemWasDropped:(ItemIndex)item
{
    if (item == II_NULL)
        return;
    // the current number of this item
    int nNum = [[_items objectAtIndex:item] intValue];
    if (nNum == II_UNKNOWN)
        nNum = 0;
    // to increment the number
    [_items replaceObjectAtIndex:item withObject:[NSNumber numberWithInt:nNum + 1]];
    // to animate the drop
    [self animateDrop:item];
}

- (void)itemShouldRotate:(NSTimer *)timer
{
    // the index
    NSNumber* data = (NSNumber*)timer.userInfo;
    int nIndex = [data intValue];
    // the current ticks
    int nTickCounts = [[_tickCounts objectAtIndex:nIndex] intValue];
    // the image view to be rotated
    UIImageView* iv = [_droppedItems objectAtIndex:nIndex];
    iv.transform = CGAffineTransformRotate(iv.transform, SPEED_ROTATION);
    // to update the tick counts
    nTickCounts++;
    [_tickCounts replaceObjectAtIndex:nIndex withObject:[NSNumber numberWithInt:nTickCounts]];
    if (nTickCounts > NUM_ROTATIONS / 4 - 2)
        [[_timers objectAtIndex:nIndex] invalidate];
}

// delegate
- (void)letterWasSelected:(NSString*)letter index:(int)index
{
    // to add the brick index into the array
    [_bricks addObject:[NSNumber numberWithInt:index]];
    // to update the word in the title view
    [_titleView addLetter:letter];
    // the word so far
    NSString* strWord = [[_titleView getLetters] lowercaseString];
    BOOL bFound = [_trie containsObjectForKeyWithPrefix:strWord];
    if (bFound)
    {
        // to drop an item
        [self itemWasDropped:[[[ItemDropModel alloc] init:DROP_RATE_FACTOR[_level]] dropAnItem]];
        // to update the view
        [_playView reshuffle];
        [_titleView clearLetters];
        [_titleView incrementHits];
        // to update the hits of the word
        for (Word* word in _lib.fkLibWords)
            if ([word.word isEqualToString:strWord])
            {
                word.hits = [NSNumber numberWithInt:[word.hits intValue] + 1];
                // Database is updated when the view disappears;
                // The experienc points gained is the length of the found word.
                int exp = [_player.experience intValue] + strWord.length * (_level + 1);
                int level = [_player.level intValue];
                if (level != MAX_LEVEL)
                {
                    if (exp >= LEVEL_THRESHOLD[level])
                        level++;
                    _player.experience = [NSNumber numberWithInt:exp];
                    _player.level = [NSNumber numberWithInt:level];
                }
                else
                    break;
            }
        // to remove all recorded indices
        [_bricks removeAllObjects];
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
    [_playView reset];
    [_titleView clearLetters];
}
- (void)titleViewWasSwipedOver
{
    if (!_usableItemView)
    {
        CGRect rc = CGRectMake(_titleView.frame.origin.x + _titleView.frame.size.width,
                               _titleView.frame.origin.y,
                               _titleView.frame.size.width,
                               _titleView.frame.size.height);
        _usableItemView = [[UsableItemView alloc] initWithFrame:rc];
        _usableItemView.delegate = self;
        [self.view addSubview:_usableItemView];
    }
    // the number of usable items
    NSMutableArray* items = [[NSMutableArray alloc] init];
    for (int i = 0; i < NUM_USABLE; i++)
    {
        NSNumber* num = [_items objectAtIndex:USABLE_INDEX[i]];
        [items addObject:num];
    }
    // to show the view
    [_usableItemView initItems:items];
    [UIView animateWithDuration:.8
                     animations:^{
                         CGRect rc = CGRectMake(_titleView.frame.origin.x - 35,
                                                _titleView.frame.origin.y,
                                                _titleView.frame.size.width,
                                                _titleView.frame.size.height);
                         _usableItemView.frame = rc;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:.3
                                          animations:^{
                                              _usableItemView.frame = _titleView.frame;
                                          }];
                     }];
}

- (void)usableItemViewWasSwipedOver
{
    // to hide the view
    [UIView animateWithDuration:.8
                     animations:^{
                         CGRect rc = CGRectMake(_titleView.frame.origin.x + _titleView.frame.size.width,
                                                _titleView.frame.origin.y,
                                                _titleView.frame.size.width,
                                                _titleView.frame.size.height);
                         _usableItemView.frame = rc;
                     }];
}

- (void)usableItemWasSelected:(ItemIndex)item
{
    switch (item)
    {
        case II_WATCH:
            [_titleView stopTimerFor:5];
            break;
        case II_POWEREDWATCH:
            [_titleView stopTimerFor:15];
            break;
        case II_KING:
            [_playView reshuffle];
            break;
        case II_MAGNIFIER:
            [_titleView clearLetters];
            [_playView find];
            break;
        default:
            return;
    }
    // to update the number of this item
    int nNum = [[_items objectAtIndex:item] intValue];
    nNum--;
    [_items replaceObjectAtIndex:item withObject:[NSNumber numberWithInt:nNum]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Time's Up"])
    {
        if (buttonIndex == 0) // "No" button is tapped
            [self.navigationController popToRootViewControllerAnimated:YES];
        else // Yes button is tapped
        {
            [_playView reshuffle];
            [_titleView restart];
        }
    } else if ([alertView.title isEqualToString:@"No Words In This Library"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if ([alertView.title isEqualToString:@"Game In Progress"])
    {
        if (buttonIndex == 1)
            [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
