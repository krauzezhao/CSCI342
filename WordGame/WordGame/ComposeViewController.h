//
//  ComposeViewController.h
//  WordGame
//
//  Created by Brendan Dickinson on 18/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemCell.h"
#import "ComposeCollectionView.h"
#import <math.h>

@interface ComposeViewController : UIViewController <ComposeCollectionViewDelegate,
                                                     ItemCellDelegate>

@property (weak, nonatomic) IBOutlet ComposeCollectionView *cvCompose;
@property (weak, nonatomic) IBOutlet UIPageControl *pcPage;

@property (strong, nonatomic) UIImageView* ivDragged;
@property CGPoint ptTap; // the coordinate of the drag starting point

@end
