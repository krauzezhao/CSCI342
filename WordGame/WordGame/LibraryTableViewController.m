//
//  LibraryTableViewController.m
//  WordGame
//
//  Created by Hong Zhao on 7/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "LibraryTableViewController.h"

@interface LibraryTableViewController ()

@end

@implementation LibraryTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _ipSel = nil;
    // the database context
    _moc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

// to retrieve data
- (void)viewWillAppear:(BOOL)animated
{
    NSFetchRequest* fr = [[NSFetchRequest alloc] init];
    // the entity
    NSEntityDescription* ed = [NSEntityDescription entityForName:@"Library"
                                          inManagedObjectContext:_moc];
    [fr setEntity:ed];
    // the result
    NSError* err = nil;
    _libs = [[_moc executeFetchRequest:fr error:&err] mutableCopy];
    [self.tableView reloadData];
}

// to update the database
- (void)viewWillDisappear:(BOOL)animated
{
    // the database
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
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _libs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    
    Library* lib = [_libs objectAtIndex:indexPath.row];
    cell.textLabel.text = lib.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Usage: %d", [lib.usage intValue]];
    if ([lib.selected boolValue])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if (!_ipSel)
            _ipSel = indexPath;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

// Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Library* lib = [_libs objectAtIndex:indexPath.row];
    if (![lib.selected boolValue]) // unselected
    {
        lib.selected = [NSNumber numberWithBool:YES];
        [_libs replaceObjectAtIndex:indexPath.row withObject:lib];
        // to uncheck the previously selected row
        if (_ipSel.row != indexPath.row)
        {
            lib = [_libs objectAtIndex:_ipSel.row];
            lib.selected = [NSNumber numberWithBool:NO];
            [_libs replaceObjectAtIndex:_ipSel.row withObject:lib];
            // to save the currently selected index path
            _ipSel = indexPath;
        }
        [tableView reloadData];
    }
}

@end
