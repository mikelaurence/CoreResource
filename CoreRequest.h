//
//  CoreRequest.h
//  CoreResource
//
//  Created by Mike Laurence on 12/31/09.
//  Copyright 2009 Mike Laurence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface CoreRequest : ASIHTTPRequest {
    id coreDelegate;
    SEL coreSelector;
    
    NSString* bundleDataPath;
    NSString* bundleDataResult;
}

@property (nonatomic, retain) id coreDelegate;
@property (nonatomic, assign) SEL coreSelector;

@property (nonatomic, retain) NSString* bundleDataPath;
@property (nonatomic, retain) NSString* bundleDataResult;

- (void) executeAsBundleRequest;

@end
