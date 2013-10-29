//
//  DefinitionViewController.h
//  WordGame
//
//  Created by Brendan Dickinson on 24/10/13.
//  Copyright (c) 2013 Hong Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

__unused static const char* WEBSERVICE =
    "http://services.aonaware.com/DictService/DictService.asmx/DefineInDict?dictID=gcide&word=";

@interface DefinitionViewController : UIViewController <NSURLConnectionDelegate,
                                                        NSURLConnectionDataDelegate,
                                                        NSXMLParserDelegate,
                                                        UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *tvDefinition;

// the view to wait for network done
@property (strong, nonatomic) UIActivityIndicatorView* aivWaiting;

@property (strong, nonatomic) NSString* strWord; // the word to be defined
@property (strong, nonatomic) NSString* strCurElement; // the current element during xml parsing
@property (strong, nonatomic) NSMutableData* xmlData; // the xml data

@end
