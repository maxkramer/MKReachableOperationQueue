//
//  ViewController.m
//  Demo
//
//  Created by Max Kramer on 21/03/2013.
//  Copyright (c) 2013 Max Kramer. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
