MKReachableOperationQueue
=========================

MKReachableOperationQueue is an NSOperationQueue subclass that automatically responds to changes in internet connection with thanks to Apple's Reachability.

##Installation
==============
###Cocoapods

Add pod `'MKReachableOperationQueue'` to your Podfile.

	pod 'MKReachableOperationQueue', '~>1.0.0'

###Old-School

Add the `MKReachableOperationQueue.{h,m}` and `Reachability.{h,m}` files to your Xcode project.

#####Important
==============

- Apple's Reachability requires the `SystemConfiguration.framework`, so please make sure that you have linked it to your project.

- If your project is not using ARC, please enable ARC for `MKReachableOperationQueue.m` by adding the Compiler Flag `-fobjc-arc`.

- However, if your project is using ARC, please disable ARC for the Reachability.m file by adding the Compiler Flag `-fno-objc-arc`.

##Usage
=======

You can instantiate an MKReachableOperationQueue object as normal, but make sure that you set the `suspendQueueWhenUnreachable` property to `YES` if you would like the subclass to automatically respond to the changes. If this property is set to `NO`, the callback will called without a change in the state of the queue. In this case, you would have to manage the suspension.

    //instantiate the queue
    
    self.operationQueue = [[MKReachableOperationQueue alloc] init];
    
    //set the property to use to automatically respond to dropped internet connection
    [self.operationQueue setSuspendQueueWhenUnreachable:YES];
    
    //the callback that is called upon a change in the state of the internet connection
    //i.e. No connection to connection or vice-versa
    [self.operationQueue setReachabilityChangedBlock:^(BOOL isReachable) {
                        
		// respond to the change in internet connection
        
    }];

##License
=========

Copyright (c) 2013 Max Kramer
 
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
