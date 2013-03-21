//
//  MKReachableOperationQueue.m
//  Linetime
//
//  Created by Max Kramer on 19/03/2013.
//  Copyright (c) 2013 Max Kramer. All rights reserved.
//

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
