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
    _vPlay.delegate = self;
    _tvTitle.delegate = self;
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
    _player.items = _items;
    //_player.items = [NSMutableArray arrayWithArray:_items];
    //[_player setValue:_items forKey:@"items"];
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
    CGRect rcBrick = [_vPlay getFrameOfBrick:nIndex];
    // to convert the frame to the current reference
    rcBrick = CGRectMake(self.view.frame.origin.x + rcBrick.origin.x,
                         _tvTitle.frame.size.height + rcBrick.origin.y,
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
    [_tvTitle addLetter:letter];
    // the word so far
    NSString* strWord = [[_tvTitle getLetters] lowercaseString];
    BOOL bFound = [_trie containsObjectForKeyWithPrefix:strWord];
    if (bFound)
    {
        // to drop an item
        [self itemWasDropped:[[[ItemDropModel alloc] init] dropAnItem]];
        // to update the view
        [_vPlay reshuffle];
        [_tvTitle clearLetters];
        [_tvTitle incrementHits];
        // to update the hits of the word
        for (Word* word in _lib.fkLibWords)
            if ([word.word isEqualToString:strWord])
            {
                word.hits = [NSNumber numberWithInt:[word.hits intValue] + 1];
                // Database is updated when the view disappears;
                // The experienc points gained is the length of the found word.
                int exp = [_player.experience intValue] + strWord.length;
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
    [_vPlay reset];
    [_tvTitle clearLetters];
}
- (void)titleViewWasSwipedOver
{
    if (!_vUsableItems)
    {
        CGRect rc = CGRectMake(_tvTitle.frame.origin.x + _tvTitle.frame.size.width,
                               _tvTitle.frame.origin.y,
                               _tvTitle.frame.size.width,
                               _tvTitle.frame.size.height);
        _vUsableItems = [[UsableItemView alloc] initWithFrame:rc];
        _vUsableItems.delegate = self;
        [self.view addSubview:_vUsableItems];
    }
    // the number of usable items
    NSMutableArray* items = [[NSMutableArray alloc] init];
    for (int i = 0; i < NUM_USABLE; i++)
    {
        NSNumber* num = [_items objectAtIndex:USABLE_INDEX[i]];
        [items addObject:num];
    }
    // to show the view
    [_vUsableItems initItems:items];
    [UIView animateWithDuration:.8
                     animations:^{
                         CGRect rc = CGRectMake(_tvTitle.frame.origin.x - 35,
                                                _tvTitle.frame.origin.y,
                                                _tvTitle.frame.size.width,
                                                _tvTitle.frame.size.height);
                         _vUsableItems.frame = rc;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:.3
                                          animations:^{
                                              _vUsableItems.frame = _tvTitle.frame;
                                          }];
                     }];
}

- (void)usableItemViewWasSwipedOver
{
    // to hide the view
    [UIView animateWithDuration:.8
                     animations:^{
                         CGRect rc = CGRectMake(_tvTitle.frame.origin.x + _tvTitle.frame.size.width,
                                                _tvTitle.frame.origin.y,
                                                _tvTitle.frame.size.width,
                                                _tvTitle.frame.size.height);
                         _vUsableItems.frame = rc;
                     }];
}

- (void)usableItemWasSelected:(ItemIndex)item
{
    switch (item)
    {
        case II_WATCH:
            break;
        case II_POWEREDWATCH:
            break;
        case II_KING:
            [_vPlay reset];
            break;
        case II_MAGNIFIER:
            break;
        default:
            return;
    }
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
