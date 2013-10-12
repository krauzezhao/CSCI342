//
//  BuildViewController.m
//  WordGame
//
//  Created by Brendan Dickinson on 10/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "BuildViewController.h"

@interface BuildViewController ()

@end

@implementation BuildViewController

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
    /*
    NSURL* urlSRU = [NSURL URLWithString:@"http://www.oed.com/srupage?operation=searchRetrieve&query=cql.serverChoice+=+%22mountain+g*%22&maximumRecords=100&startRecord=1"];
    NSURLRequest* req = [NSURLRequest requestWithURL:urlSRU];
    NSURLConnection* conn = [NSURLConnection connectionWithRequest:req delegate:self];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* huResponse = (NSHTTPURLResponse*)response;
    int nStatus = huResponse.statusCode;
    NSString* strFileType = [[huResponse MIMEType] lowercaseString];
    NSLog(@"%d, %@", nStatus, strFileType);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

@end
