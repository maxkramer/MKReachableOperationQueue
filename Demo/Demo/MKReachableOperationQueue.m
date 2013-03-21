//
//  MKReachableOperationQueue.m
//  Linetime
//
//  Created by Max Kramer on 19/03/2013.
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

#import "MKReachableOperationQueue.h"
#import "Reachability.h"

@interface MKReachableOperationQueue ()

@property (nonatomic, strong) Reachability *_currentReachability;

@end

@implementation MKReachableOperationQueue
@synthesize _currentReachability, suspendQueueWhenUnreachable, reachabilityChangedBlock;

- (Reachability *) _currentReachability {
    
    if (self.suspendQueueWhenUnreachable == YES && _currentReachability) {
        
        [self setSuspended:(_currentReachability.currentReachabilityStatus == NotReachable)];
        
    }
    
    if (!_currentReachability) {
        
        _currentReachability = [Reachability reachabilityForInternetConnection];
        [_currentReachability startNotifier];
    
        [[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification object:_currentReachability queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification *note) {
           
            BOOL isReachable = (_currentReachability.currentReachabilityStatus != NotReachable);
            
            if (self.reachabilityChangedBlock) { self.reachabilityChangedBlock(isReachable); }
            
            if (self.suspendQueueWhenUnreachable == YES) {
             
                [self setSuspended:!isReachable];
                                
            }
            
        }];
        
    }
    
    return _currentReachability;
    
}

- (id) init {
    
    if ((self = [super init])) {
        
        [self setSuspended:(_currentReachability.currentReachabilityStatus == NotReachable)];
        [self setName:@"MKReachableOperationQueue"];
        [self setSuspendQueueWhenUnreachable:YES];
        [self _currentReachability];
        
    }
    
    return self;
    
}

- (void) setSuspendQueueWhenUnreachable:(BOOL) newSuspendQueueWhenUnreachable {
    suspendQueueWhenUnreachable = newSuspendQueueWhenUnreachable;
    if (self._currentReachability.currentReachabilityStatus == NotReachable) { [self setSuspended:NO]; }
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:_currentReachability];
    
}

@end
