//
//  ViewController.m
//  Demo
//
//  Created by Max Kramer on 21/03/2013.
//  Copyright (c) 2013 Max Kramer. All rights reserved.
//

#import "ViewController.h"
#import "MKReachableOperationQueue.h"

@interface ViewController () <UIWebViewDelegate>

@property (nonatomic, strong) MKReachableOperationQueue *operationQueue;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ViewController
@synthesize operationQueue, webView;

- (void)viewDidLoad
{
    self.webView = [[UIWebView alloc] initWithFrame:[self.view frame]];
    [self.webView setDelegate:self];
    [self.webView setScalesPageToFit:YES];
    [self.webView setDataDetectorTypes:UIDataDetectorTypeAll];
    [self.view addSubview:self.webView];
    
    [super viewDidLoad];
    
    self.operationQueue = [[MKReachableOperationQueue alloc] init];
    [self.operationQueue setSuspendQueueWhenUnreachable:YES];
    [self.operationQueue setReachabilityChangedBlock:^(BOOL isReachable) {
                        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MKReachableNetworkQueue" message:[NSString stringWithFormat:@"I am %@connected to the internet", (isReachable == YES ? @"" : @"not ")] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        
    }];
        
    NSURL *url = [NSURL URLWithString:@"https://www.apple.com/uk"];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0f] queue:[self operationQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
       
        BOOL isMainThread = [[NSThread currentThread] isEqual:[NSThread mainThread]];
                        
        void (^displayGoogleBlock)() = ^{
            [self.webView loadData:data MIMEType:[response MIMEType] textEncodingName:[response textEncodingName] baseURL:url];
        };
        
        (isMainThread ? displayGoogleBlock() : dispatch_async(dispatch_get_main_queue(), displayGoogleBlock));
        
    }];
    
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Unabled to load. Error: %@", error);
}

@end
