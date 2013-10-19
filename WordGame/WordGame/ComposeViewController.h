//
//  ComposeViewController.h
//  WordGame
//
//  Created by Brendan Dickinson on 18/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Item.h"
#import "ItemCell.h"
#import "ComposeCollectionView.h"
#import "Player.h"

@interface ComposeViewController : UIViewController <ComposeCollectionViewDelegate,
                                                     ItemCellDelegate>

@property (weak, nonatomic) IBOutlet ComposeCollectionView *cvCompose;
@property (weak, nonatomic) IBOutlet UIPageControl *pcPage;

@property (strong, nonatomic) UIImageView* ivDragged;

@property (strong, nonatomic) NSManagedObjectContext* moc;
@property (strong, nonatomic) Player* player;

@end
