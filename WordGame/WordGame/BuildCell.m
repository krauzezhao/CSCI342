//
//  BuildCell.m
//  WordGame
//
//  Created by Brendan Dickinson on 14/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "BuildCell.h"

@implementation BuildCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // the input area
        _tfInput = [[UITextField alloc] initWithFrame:self.contentView.frame];
        _tfInput.font = [UIFont systemFontOfSize:18];
        [self addSubview:_tfInput];
        // the accessory
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAsLibraryName
{
    _tfInput.placeholder = @"Input Library Name";
    self.accessoryView = UITableViewCellAccessoryNone;
}

- (void)setAsWord
{
    _tfInput.placeholder = @"Input Word";
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
