//
//  CoreRequest.m
//  CoreResource
//
//  Created by Mike Laurence on 12/31/09.
//  Copyright 2009 Punkbot LLC. All rights reserved.
//

#import "CoreRequest.h"


@implementation CoreRequest

@synthesize coreDelegate, coreSelector;
@synthesize bundleDataPath, bundleDataResult;

- (void) executeAsBundleRequest {
    NSError* parseError = nil;
    self.bundleDataResult = [NSString stringWithContentsOfFile:
            [[NSBundle mainBundle] pathForResource:bundleDataPath ofType:@"json"] 
        encoding:NSUTF8StringEncoding error:&parseError];
                
    if (parseError == nil) {
        if (didFinishSelector && ![self isCancelled] && [delegate respondsToSelector:didFinishSelector])
            [delegate performSelector:didFinishSelector withObject:self];
    }
    else
        [self failWithError:parseError];
}

- (NSString*) stringData {
    return bundleDataResult != nil ? bundleDataResult : [self responseString];
}

- (NSString*) responseString {
    return bundleDataResult != nil ? bundleDataResult : [super responseString];
}

- (void) dealloc {
    [bundleDataResult release];
    [bundleDataPath release];
    [super dealloc];
}

@end
