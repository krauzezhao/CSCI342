//
//  LibrariesTableViewController.m
//  WordGame
//
//  Created by Brendan Dickinson on 14/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "LibrariesTableViewController.h"

@interface LibrariesTableViewController ()

@end

@implementation LibrariesTableViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // the db context
    _moc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// to get libraries before the view appears
- (void)viewWillAppear:(BOOL)animated
{
    NSFetchRequest* fr = [[NSFetchRequest alloc] init];
    NSEntityDescription* ed = [NSEntityDescription entityForName:@"Library"
                                          inManagedObjectContext:_moc];
    [fr setEntity:ed];
    NSError* err = nil;
    _maLib = [[_moc executeFetchRequest:fr error:&err] mutableCopy];
    if (err)
    {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Data Error"
                                                     message:@"Library Reading Error"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }
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
    return _maLib.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    
    Library* lib = [_maLib objectAtIndex:indexPath.row];
    cell.textLabel.text = lib.name;
    NSLog(@"%@", lib.date);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", lib.date];
    
    UIButton* btnWords = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [btnWords addTarget:self action:@selector(detailWasTapped)
       forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = btnWords;
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SEG_WORDS"])
    {
        // the selected data
        NSIndexPath* ip = [self.tableView indexPathForSelectedRow];
        Library* lib = [_maLib objectAtIndex:ip.row];
        // the destination view
        WordsTableViewController* wtvc = [segue destinationViewController];
        wtvc.title = lib.name;
        wtvc.words = [NSMutableArray arrayWithArray:[lib.fkLibDict allObjects]];
    }
}

// detail button is tapped
- (void)detailWasTapped
{
    [self performSegueWithIdentifier:@"SEG_WORDS" sender:nil];
}

// navigation bar item events
- (IBAction)homeWasTapped:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addWasTapped:(id)sender
{
    // the alert view for the name of the library
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Add A New Library"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"OK", nil];
    [av setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [av textFieldAtIndex:0].placeholder = @"Library Name";
    [av show];
}

// alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) // OK is tapped
    {
        NSString* strName = [alertView textFieldAtIndex:0].text;
        if (strName.length == 0) // no input
            return;
        // the library to be added
        Library* lib = [NSEntityDescription insertNewObjectForEntityForName:@"Library"
                                                     inManagedObjectContext:_moc];
        lib.name = strName;
        lib.date = [NSDate date];
        NSLog(@"%@, %@", lib.date, [NSDate date]);
        // to save the library
        NSError* err = nil;
        BOOL bSucc = [_moc save:&err];
        if (err || !bSucc)
        {
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Data Error"
                                                         message:nil
                                                        delegate:nil
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:nil];
            [av show];
            return;
        }
        [_maLib insertObject:lib atIndex:0];
        // to insert one row at the top
        NSIndexPath* insertion = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[insertion] withRowAnimation:YES];
    }
}
@end