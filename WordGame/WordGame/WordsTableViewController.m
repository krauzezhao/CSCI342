//
//  WordsTableViewController.m
//  WordGame
//
//  Created by Brendan Dickinson on 14/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "WordsTableViewController.h"

@interface WordsTableViewController ()

@end

@implementation WordsTableViewController

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
    // to register the cell
    [self.tableView registerClass:[WordCell class] forCellReuseIdentifier:@"Cell"];
    // the db context
    _moc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SEG_DEFINITION"])
    {
        // the selected word
        NSIndexPath* ip = [self.tableView indexPathForSelectedRow];
        Word* word = [_words objectAtIndex:ip.row];
        // the destination
        DefinitionViewController* dvc = segue.destinationViewController;
        dvc.strWord = word.word;
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
    return _words.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    WordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (!cell)
        cell = [[WordCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                               reuseIdentifier:CellIdentifier];
    
    Word* word = [_words objectAtIndex:indexPath.row];
    [cell setTitle:word.word];
    [cell setSubtitle:[NSString stringWithFormat:@"%@ Hits", word.hits]];
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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Word* word = [_words objectAtIndex:indexPath.row];
        // to delete the data
        [_moc deleteObject:word];
        NSError* err = nil;
        BOOL bDel = [_moc save:&err];
        if (!bDel || err)
        {
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Deletion Failed"
                                                         message:nil
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            [av show];
            return;
        }
        [_words removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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
    [self performSegueWithIdentifier:@"SEG_DEFINITION" sender:nil];
}

// events
- (IBAction)addWasTapped:(id)sender
{
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Add A Word"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"OK", nil];
    [av setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) // OK is tapped
    {
        // the word to be added
        Word* word = [NSEntityDescription insertNewObjectForEntityForName:@"Word"
                                                   inManagedObjectContext:_moc];
        word.word = [[alertView textFieldAtIndex:0].text lowercaseString];
        word.fkWordLib = _lib;
        // to save it
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
        [_words insertObject:word atIndex:0];
        // to insert one row at the top
        NSIndexPath* insertion = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[insertion] withRowAnimation:YES];
    }
}

@end
