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
    _cvCompose.ccvdDelegate = self;
    _cvCompose.itemDelegate = self;
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
        _cvCompose.player = _player;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// delegates
- (void)pageWasScrolledTo:(int)page
{
    _pcPage.currentPage = page;
}

// delegate
- (void)itemIsBeingDragged:(UIPanGestureRecognizer*)pgr center:(CGPoint)center ref:(CGPoint)ref  image:(NSString *)image
{
    // to compute the offset between 2 different refernces
    CGFloat fOffsetX = ref.x - [pgr locationInView:self.view].x;
    CGFloat fOffsetY = ref.y - [pgr locationInView:self.view].y;
    CGFloat fInitX = center.x - fOffsetX;
    CGFloat fInitY = center.y - fOffsetY;
    //NSLog(@"%f", fInitX);
    
    if (pgr.state == UIGestureRecognizerStateBegan)
    {
        // to init the drag
        _ivDragged.frame = CGRectMake(fInitX - .5, fInitY - .5, 1, 1);
        _ivDragged.image = [UIImage imageNamed:image];
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
                              completion:nil];
    } else if (pgr.state == UIGestureRecognizerStateEnded)
    {
        // to move the item back
        [UIImageView animateWithDuration:TIME_RETURN / 2
                              animations:^{
                                  CGFloat fWidth = _ivDragged.frame.size.width;
                                  CGFloat fHeight = _ivDragged.frame.size.height;
                                  _ivDragged.frame = CGRectMake(fInitX - fWidth / 2,
                                                                fInitY - fHeight / 2,
                                                                fWidth,
                                                                fHeight);
                                  
                              }
                              completion:^(BOOL finished){
                                  [UIImageView animateWithDuration:TIME_RETURN / 2
                                                        animations:^{
                                                            CGFloat fWidth = _ivDragged.frame.size.width;
                                                            CGFloat fHeight = _ivDragged.frame.size.height;
                                                            _ivDragged.frame =
                                                            CGRectMake(fInitX - fWidth * .05,
                                                                       fInitY - fHeight * .05,
                                                                       fWidth * .1,
                                                                       fHeight * .1);
                                                        }
                                                        completion:^(BOOL finished){
                                                            [_ivDragged removeFromSuperview];
                                                        }];
                              }];
        return;
    }
    // to move the item
    CGPoint ptCur = [pgr locationInView:self.view];
    _ivDragged.frame = CGRectMake(ptCur.x - _ivDragged.frame.size.width / 2,
                                  ptCur.y - _ivDragged.frame.size.height / 2,
                                  _ivDragged.frame.size.width,
                                  _ivDragged.frame.size.height);
}

@end
