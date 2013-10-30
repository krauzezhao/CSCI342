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
    _itemsView.composeCollectionViewDelegate = self;
    _itemsView.itemDelegate = self;
    _composeView.delegate = self;
    // to initialise the image view used for dragging
    _draggedItemView = [[UIImageView alloc] init];
    _draggedItemView.contentMode = UIViewContentModeScaleToFill;
    // the description view
    _itemDescriptionView = [[ItemDescriptionView alloc] init];
    // not dropped in the composition area
    _isInCompositionArea = NO;
    // the db context
    _moc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (void)viewWillAppear:(BOOL)animated
{
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
        _itemsView.items = _items;
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    // to restore all items if not confirmed yet
    if (_composeView.hasScroll)
        [_composeView cancelWasTapped:nil];
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
                              CGFloat fWidth = _draggedItemView.frame.size.width;
                              CGFloat fHeight = _draggedItemView.frame.size.height;
                              _draggedItemView.frame = CGRectMake(ptInitial.x - fWidth / 2,
                                                            ptInitial.y - fHeight / 2,
                                                            fWidth,
                                                            fHeight);
                              
                          }
                          completion:^(BOOL finished){
                              [UIImageView animateWithDuration:TIME_RETURN / 2
                                                    animations:^{
                                                        CGFloat fWidth = _draggedItemView.frame.size.width;
                                                        CGFloat fHeight = _draggedItemView.frame.size.height;
                                                        _draggedItemView.frame =
                                                        CGRectMake(ptInitial.x - fWidth * .05,
                                                                   ptInitial.y - fHeight * .05,
                                                                   fWidth * .1,
                                                                   fHeight * .1);
                                                    }
                                                    completion:^(BOOL finished){
                                                        [_draggedItemView setHidden:YES];
                                                    }];
                          }];
}

- (void)showMessage
{
    [_messageLabel setHidden:NO];
    _messageLabel.alpha = 0;
    [UILabel animateWithDuration:.5
                      animations:^{
                          _messageLabel.alpha = 1;
                      }
                      completion:nil];
}

- (void)itemDescriptionShouldFadeOut
{
    [UIView animateWithDuration:.3
                     animations:^{
                         _itemDescriptionView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [_itemDescriptionView removeFromSuperview];
                     }];
}

// delegates
- (void)pageWasScrolledTo:(int)page
{
    [_itemDescriptionView removeFromSuperview];
    _pageControl.currentPage = page;
}

- (void)itemIsBeingDragged:(UIPanGestureRecognizer*)pgr center:(CGPoint)center ref:(CGPoint)ref  item:(ItemIndex)item
{
    if (pgr.state == UIGestureRecognizerStateBegan)
    {
        _isInCompositionArea = NO;
        // to compute the offset between 2 different refernces
        CGFloat fOffsetX = ref.x - [pgr locationInView:self.view].x;
        CGFloat fOffsetY = ref.y - [pgr locationInView:self.view].y;
        _initialPoint.x = center.x - fOffsetX;
        _initialPoint.y = center.y - fOffsetY;
        // to init the drag
        _draggedItemView.frame = CGRectMake(_initialPoint.x - .5, _initialPoint.y - .5, 1, 1);
        _draggedItemView.image =
            [UIImage imageNamed:[NSString stringWithFormat:@"%s%s", PREFIX_AVAIL, ITEM[item]]];
        [_draggedItemView setHidden:NO];
        [self.view addSubview:_draggedItemView];
        [UIImageView animateWithDuration:.2
                              animations:^{
                                  CGFloat fX = _draggedItemView.frame.origin.x;
                                  CGFloat fY = _draggedItemView.frame.origin.y;
                                  CGFloat fWidth = _draggedItemView.frame.size.width;
                                  CGFloat fHeight = _draggedItemView.frame.size.height;
                                  _draggedItemView.frame = CGRectMake(fX - fWidth * 40,
                                                                fY - fHeight * 40,
                                                                fWidth * 80,
                                                                fHeight * 80);
                              }
                              completion:^(BOOL finished){
                                  // to record the size of the image
                                  _itemSize = _draggedItemView.frame.size;
                              }];
        // to decrement the number of the items
        int nNum = [[_items objectAtIndex:item] intValue];
        nNum--;
        [_items replaceObjectAtIndex:item withObject:[NSNumber numberWithInt:nNum]];
        [_itemsView setNumberOfItems:item num:nNum animated:NO];
    } else if (pgr.state == UIGestureRecognizerStateEnded)
    {
        if (!_isInCompositionArea)
        {
            [self moveBackItem:_initialPoint];
            // to increment the number of the items
            int nNum = [[_items objectAtIndex:item] intValue];
            nNum++;
            [_items replaceObjectAtIndex:item withObject:[NSNumber numberWithInt:nNum]];
            [_itemsView setNumberOfItems:item num:nNum animated:NO];
            return; // not dropped inside the composition area
        }
        ItemDropStatus ids = [_composeView itemWasDropped:item];
        if (ids != IDS_SUCCESS)
        {
            // to show the message label
            if (ids == IDS_NOSCROLL)
                [self showMessage];
            // to move the item back
            [self moveBackItem:_initialPoint];
            // to increment the number of the items
            int nNum = [[_items objectAtIndex:item] intValue];
            nNum++;
            [_items replaceObjectAtIndex:item withObject:[NSNumber numberWithInt:nNum]];
            [_itemsView setNumberOfItems:item num:nNum animated:NO];
        } else // ready to be composed
        {
            [_messageLabel setHidden:YES];
            [_draggedItemView setHidden:YES];
        }
    } else
    {
        // to move the item
        CGPoint ptCur = [pgr locationInView:self.view];
        _draggedItemView.frame = CGRectMake(ptCur.x - _draggedItemView.frame.size.width / 2,
                                      ptCur.y - _draggedItemView.frame.size.height / 2,
                                      _draggedItemView.frame.size.width,
                                      _draggedItemView.frame.size.height);
        // to check for intersection between the dragged item and the compose view
        if (CGRectIntersectsRect(_draggedItemView.frame, _composeView.frame))
        {
            _isInCompositionArea = YES;
            [UILabel animateWithDuration:.5
                              animations:^{
                                  _messageLabel.alpha = 0;
                              }
                              completion:nil];
        }
        else
        {
            _isInCompositionArea = NO;
            [UILabel animateWithDuration:.5
                              animations:^{
                                  _messageLabel.alpha = 1;
                              }
                              completion:nil];
        }
    }
}

- (void)itemWasTapped:(UITapGestureRecognizer*)tgr center:(CGPoint)center ref:(CGPoint)ref item:(ItemIndex)item
{
    [_timer invalidate];
    // to compute the center of the item cell relative to the super view
    CGFloat fOffsetX = ref.x - [tgr locationInView:self.view].x;
    CGFloat fOffsetY = ref.y - [tgr locationInView:self.view].y;
    CGFloat fCenterX = center.x - fOffsetX;
    CGFloat fCenterY = center.y - fOffsetY;
    // to determine the description view's position
    // The default is to align the top left of the description view to the center of the tapped item
    CGFloat fWidth = self.view.frame.size.width * PERCENTAGE_WIDTH_DESCRIPTIONVIEW;
    CGFloat fHeight = self.view.frame.size.height * PERCENTAGE_HEIGHT_DESCRIPTIONVIEW;
    CGRect rcDescription = CGRectMake(fCenterX, fCenterY, fWidth, fHeight);
    if (fCenterX + fWidth > self.view.frame.size.width)
    { // The right of the description view should be aligned to fCenterX
        rcDescription.origin = CGPointMake(fCenterX - fWidth, fCenterY);
    }
    if (fCenterY + fHeight > self.view.frame.size.height)
    { // The bottom of the description view should be aligned to fCenterY
        rcDescription.origin = CGPointMake(rcDescription.origin.x, fCenterY - fHeight);
    }
    // the description view
    if (_itemDescriptionView)
        [_itemDescriptionView removeFromSuperview];
    _itemDescriptionView.alpha = .8;
    _itemDescriptionView.frame = rcDescription;
    [_itemDescriptionView setItem:item];
    [self.view addSubview:_itemDescriptionView];
    // This view disappears in 5 seconds
    _timer = [NSTimer scheduledTimerWithTimeInterval:5
                                              target:self
                                            selector:@selector(itemDescriptionShouldFadeOut)
                                            userInfo:nil
                                             repeats:NO];
}

- (void)cancelWasTapped:(ItemIndex)scroll items:(NSMutableArray*)items
{
    ///*** to restore the number of items ***///
    // the scroll
    int nNum = [[_items objectAtIndex:scroll] intValue];
    nNum++;
    [_items replaceObjectAtIndex:scroll withObject:[NSNumber numberWithInt:nNum]];
    [_itemsView setNumberOfItems:scroll num:nNum animated:NO];
    // the items
    for (NSNumber* index in items)
    {
        nNum = [[_items objectAtIndex:[index intValue]] intValue];
        nNum++;
        [_items replaceObjectAtIndex:[index intValue] withObject:[NSNumber numberWithInt:nNum]];
        [_itemsView setNumberOfItems:[index intValue] num:nNum animated:NO];
    }
    ///*** end ***///
    // to show the message label
    [_messageLabel setHidden:NO];
    [self showMessage];
}

- (void)discardWasTapped:(ItemIndex)result
{
    UIAlertView* av =
        [[UIAlertView alloc] initWithTitle:@"Do you really want to discard this item?"
                                   message:@"Once discarded, you won't get anything back."
                                  delegate:self
                         cancelButtonTitle:@"Cancel"
                         otherButtonTitles:@"Discard", nil];
    [av show];
}

- (void)okWasTapped:(ItemIndex)result
{
    // to update the items
    int nNum = [[_items objectAtIndex:result] intValue];
    if (nNum < 0)
        nNum = 1;
    else
        nNum++;
    [_itemsView setNumberOfItems:result num:nNum animated:YES];
    // to update the player
    [_items replaceObjectAtIndex:result withObject:[NSNumber numberWithInt:nNum]];
    // to show the drag hint
    [self showMessage];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) // Discard
    {
        [_composeView discard];
        // to show the message label
        [self showMessage];
    }
}

@end
