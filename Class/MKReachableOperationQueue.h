//
//  MKReachableOperationQueue.h
//  Linetime
//
//  Created by Max Kramer on 19/03/2013.
//  Copyright (c) 2013 Max Kramer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MKReachableOperationQueueNetworkStatusChangedBlock)(BOOL isReachable);

@interface MKReachableOperationQueue : NSOperationQueue

@property (nonatomic, strong) MKReachableOperationQueueNetworkStatusChangedBlock reachabilityChangedBlock;
@property (nonatomic, assign) BOOL suspendQueueWhenUnreachable;

@end
