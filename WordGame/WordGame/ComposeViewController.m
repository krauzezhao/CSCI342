//
//  ComposeViewController.m
//  WordGame
//
//  Created by Brendan Dickinson on 18/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "ComposeViewController.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController

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
    _ccvItems.ccvdDelegate = self;
    _ccvItems.itemDelegate = self;
    _cvCompose.delegate = self;
    // to initialise the image view used for dragging
    _ivDragged = [[UIImageView alloc] init];
    _ivDragged.contentMode = UIViewContentModeScaleToFill;
    // the db context
    _moc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    // to get the Player object
    NSFetchRequest* fr = [[NSFetchRequest alloc] init];
    NSEntityDescription* ed = [NSEntityDescription entityForName:@"Player"
                                          inManagedObjectContext:_moc];
    [fr setEntity:ed];
    NSError* err = nil;
    NSMutableArray* results = [[_moc executeFetchRequest:fr error:&err] mutableCopy];
    if (err || results.count == 0)
    {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Data Error"
                                                     message:@"Player Reading Error"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    } else
    {
        _player = [results objectAtIndex:0];
        _items = _player.items;
        _ccvItems.player = _player;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    // to update the database
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// functions
- (void)moveBackItem:(CGPoint)ptInitial
{
    // to move the item back
    [UIImageView animateWithDuration:TIME_RETURN / 2
                          animations:^{
                              CGFloat fWidth = _ivDragged.frame.size.width;
                              CGFloat fHeight = _ivDragged.frame.size.height;
                              _ivDragged.frame = CGRectMake(ptInitial.x - fWidth / 2,
                                                            ptInitial.y - fHeight / 2,
                                                            fWidth,
                                                            fHeight);
                              
                          }
                          completion:^(BOOL finished){
                              [UIImageView animateWithDuration:TIME_RETURN / 2
                                                    animations:^{
                                                        CGFloat fWidth = _ivDragged.frame.size.width;
                                                        CGFloat fHeight = _ivDragged.frame.size.height;
                                                        _ivDragged.frame =
                                                        CGRectMake(ptInitial.x - fWidth * .05,
                                                                   ptInitial.y - fHeight * .05,
                                                                   fWidth * .1,
                                                                   fHeight * .1);
                                                    }
                                                    completion:^(BOOL finished){
                                                        [_ivDragged setHidden:YES];
                                                    }];
                          }];
}

// delegates
- (void)pageWasScrolledTo:(int)page
{
    _pcPage.currentPage = page;
}

- (void)itemIsBeingDragged:(UIPanGestureRecognizer*)pgr center:(CGPoint)center ref:(CGPoint)ref  item:(ItemIndex)item
{
    if (pgr.state == UIGestureRecognizerStateBegan)
    {
        // to compute the offset between 2 different refernces
        CGFloat fOffsetX = ref.x - [pgr locationInView:self.view].x;
        CGFloat fOffsetY = ref.y - [pgr locationInView:self.view].y;
        _ptInitial.x = center.x - fOffsetX;
        _ptInitial.y = center.y - fOffsetY;
        // to init the drag
        _ivDragged.frame = CGRectMake(_ptInitial.x - .5, _ptInitial.y - .5, 1, 1);
        _ivDragged.image =
            [UIImage imageNamed:[NSString stringWithFormat:@"%s%s", PREFIX_AVAIL, ITEM[item]]];
        [_ivDragged setHidden:NO];
        [self.view addSubview:_ivDragged];
        [UIImageView animateWithDuration:.2
                              animations:^{
                                  CGFloat fX = _ivDragged.frame.origin.x;
                                  CGFloat fY = _ivDragged.frame.origin.y;
                                  CGFloat fWidth = _ivDragged.frame.size.width;
                                  CGFloat fHeight = _ivDragged.frame.size.height;
                                  _ivDragged.frame = CGRectMake(fX - fWidth * 40,
                                                                fY - fHeight * 40,
                                                                fWidth * 80,
                                                                fHeight * 80);
                              }
                              completion:^(BOOL finished){
                                  // to record the size of the image
                                  _szItem = _ivDragged.frame.size;
                              }];
    } else if (pgr.state == UIGestureRecognizerStateEnded)
    {
        ItemDropStatus ids = [_cvCompose itemWasDropped:item];
        if (ids != IDS_SUCCESS)
        {
            // to show the message label
            if (ids == IDS_NOSCROLL)
                [UILabel animateWithDuration:.5
                                  animations:^{
                                      _lblMsg.alpha = 1;
                                  }
                                  completion:nil];
            // to move the item back
            [self moveBackItem:_ptInitial];
        } else
        {
            [_lblMsg setHidden:YES];
            [_ivDragged setHidden:YES];
        }
    } else
    {
        // to move the item
        CGPoint ptCur = [pgr locationInView:self.view];
        _ivDragged.frame = CGRectMake(ptCur.x - _ivDragged.frame.size.width / 2,
                                      ptCur.y - _ivDragged.frame.size.height / 2,
                                      _ivDragged.frame.size.width,
                                      _ivDragged.frame.size.height);
        // to check for intersection between the dragged item and the compose view
        if (CGRectIntersectsRect(_ivDragged.frame, _cvCompose.frame))
            [UILabel animateWithDuration:.5
                              animations:^{
                                  _lblMsg.alpha = 0;
                              }
                              completion:nil];
        else
            [UILabel animateWithDuration:.5
                              animations:^{
                                  _lblMsg.alpha = 1;
                              }
                              completion:nil];
    }
}

- (void)cancelWasTapped:(CGPoint)center scroll:(ItemIndex)scroll
{
//    // to map the center to the current coordinate reference
//    CGFloat fCenterX = center.x + _cvCompose.frame.origin.x;
//    CGFloat fCenterY = center.y + _cvCompose.frame.origin.y;
//    // the frame of the scroll
//    CGFloat fX = fCenterX - _szItem.width / 2;
//    CGFloat fY = fCenterY - _szItem.height / 2;
//    _ivDragged.frame = CGRectMake(fX, fY, _szItem.width, _szItem.height);
//    // to show the scroll
//    _ivDragged.image =
//        [UIImage imageNamed:[NSString stringWithFormat:@"%s%s", PREFIX_AVAIL, ITEM[scroll]]];
//    [_ivDragged setHidden:NO];
//    // to move the scroll back
//    [self moveBackItem:_ptInitialScroll];
    // to show the message label
    [_lblMsg setHidden:NO];
    [UILabel animateWithDuration:.5
                      animations:^{
                          _lblMsg.alpha = 1;
                      }
                      completion:nil];

}

@end
