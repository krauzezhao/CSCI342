//
//  WordViewController.m
//  WordGame
//
//  Created by Brendan Dickinson on 14/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "WordViewController.h"

@interface WordViewController ()

@end

@implementation WordViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    // the web service to fetch the definition
    NSURL* url = [NSURL URLWithString:WS_URL];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    // HTTP header
    [req setHTTPMethod:@"GET"];
    [req setValue:WS_KEY forHTTPHeaderField:WS_FIELD_KEY];
    [req setValue:WS_ACCEPT forHTTPHeaderField:WS_FIELD_ACCEPT];
    [req setValue:WS_PAGEINDEX forHTTPHeaderField:WS_FIELD_PAGEINDEX];
    [req setValue:WS_PAGESIZE forHTTPHeaderField:WS_FIELD_PAGESIZE];
    [req setValue:_strWord forHTTPHeaderField:@"q"];
    // to connect to the web service
    NSURLConnection* conn = [NSURLConnection connectionWithRequest:req delegate:self];
    if (!conn)
    {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Network Connection Failure"
                                                     message:@"Please Check Your Network"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }
}

// web service delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* hur = (NSHTTPURLResponse*)response;
    if (hur.statusCode != 200)
    {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Network Connection Failure"
                                                     message:@"Server Error"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError* err = nil;
    // the whole object
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    NSLog(@"%@", dic);
    if (err)
    {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Network Connection Failure"
                                                     message:@"Data Corrupted"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }
    // the results
    NSArray* results = [dic objectForKey:WS_JSON_RESULT];
    for (NSData* result in results)
    {
        NSDictionary* entry = [NSJSONSerialization JSONObjectWithData:result
                                                              options:NSJSONReadingMutableContainers
                                                                error:&err];
        if (err)
        {
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Network Connection Failure"
                                                         message:@"Data Corrupted"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            [av show];
            continue;
        }
        NSLog(@"%@", [entry objectForKey:@"entry_Id"]);
    }
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
}

@end
