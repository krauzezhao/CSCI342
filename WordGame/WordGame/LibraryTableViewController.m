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
    int nNum = lib.usage ? [lib.usage intValue] : 0;
    NSString* strUsage = [NSString stringWithFormat:@"Usage: %d", nNum];
    
    cell.textLabel.text = lib.name;
    cell.detailTextLabel.text = strUsage;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

// Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

// functions
- (Library*)getSelectedLibrary
{
    NSIndexPath* ip = [self.tableView indexPathForSelectedRow];
    return [_libs objectAtIndex:ip.row];
}

@end
