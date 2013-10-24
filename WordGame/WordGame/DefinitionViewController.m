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
    _strCurElement = nil;
    _xmlData = [NSMutableData dataWithCapacity:0];
    // to wait for the web service done
    _aivWaiting =
        [[UIActivityIndicatorView alloc]
            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _aivWaiting.frame = CGRectMake(0, 0, 200, 200);
    _aivWaiting.center = self.view.center;
    [self.view addSubview:_aivWaiting];
    [_aivWaiting startAnimating];
    // the web service
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%s%@", WEBSERVICE, _strWord]];
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
                                                    delegate:nil
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
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
}

// XML Parser delegates
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Data Corrupted"
                                                 message:[NSString stringWithFormat:@"%@", parseError]
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _strCurElement = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (_strCurElement && [_strCurElement isEqualToString:@"WordDefinition"])
    {
        NSString* str = [string stringByReplacingOccurrencesOfString:@"{" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"}" withString:@""];
        _tvDefinition.text = str;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    _strCurElement = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (_tvDefinition.text.length < _strWord.length)
        _tvDefinition.text = @"No Such A Word";
    [_aivWaiting stopAnimating];
}

@end
