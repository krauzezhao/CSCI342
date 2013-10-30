//
//  DefinitionViewController.m
//  WordGame
//
//  Created by Brendan Dickinson on 24/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import "DefinitionViewController.h"

@interface DefinitionViewController ()

@end

@implementation DefinitionViewController

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
    _currentElement = nil;
    _xmlData = [NSMutableData dataWithCapacity:0];
    // to wait for the web service done
    _waitingIndicator =
        [[UIActivityIndicatorView alloc]
            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _waitingIndicator.frame = CGRectMake(0, 0, 200, 200);
    _waitingIndicator.center = self.view.center;
    [self.view addSubview:_waitingIndicator];
    [_waitingIndicator startAnimating];
    // the web service
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%s%@", WEBSERVICE, _word]];
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:req delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// URL Connection delegates
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_xmlData setLength:0];
    NSHTTPURLResponse* hur = (NSHTTPURLResponse*)response;
    if (hur.statusCode != 200)
    {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Connection Failed"
                                                     message:nil
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:_xmlData];
    parser.delegate = self;
    parser.shouldProcessNamespaces = NO;
    parser.shouldReportNamespacePrefixes = NO;
    parser.shouldResolveExternalEntities = NO;
    [parser parse];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Connection Failed"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
}

// XML Parser delegates
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Data Corrupted"
                                                 message:[NSString stringWithFormat:@"%@", parseError]
                                                delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _currentElement = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (_currentElement && [_currentElement isEqualToString:@"WordDefinition"])
    {
        NSString* str = [string stringByReplacingOccurrencesOfString:@"{" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"}" withString:@""];
        _definitionTextView.text = str;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    _currentElement = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (_definitionTextView.text.length < _word.length)
        _definitionTextView.text = @"No Such A Word";
    [_waitingIndicator stopAnimating];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
