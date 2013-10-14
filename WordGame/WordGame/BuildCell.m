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
        CGRect rcInput = CGRectMake(self.contentView.frame.origin.x + SPACE_TEXTFIELD,
                                    self.contentView.frame.origin.y,
                                    self.contentView.frame.size.width * WIDTH_FACTOR,
                                    self.contentView.frame.size.height);
        _tfInput = [[UITextField alloc] initWithFrame:rcInput];
        _tfInput.delegate = self;
        _tfInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_tfInput];
        //[self initInput];
        // the accessory
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // not to highlight the selection
    //[super setSelected:selected animated:animated];

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
    // the accessory button
    UIButton* btnAcc = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [btnAcc addTarget:self
               action:@selector(accessoryWasTapped)
     forControlEvents:UIControlEventTouchUpInside];
    self.accessoryView = btnAcc;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_tfInput.placeholder isEqualToString:@"Input Library Name"])
        _litType = LIT_NAME;
    else
        _litType = LIT_WORD;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [_delegate inputWasFinished:_tfInput.text type:_litType];
    return YES;
}

// events
- (void)accessoryWasTapped
{
    [_delegate accessoryWasTapped:_tfInput.text];
}

@end
