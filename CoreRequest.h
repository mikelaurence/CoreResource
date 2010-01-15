//
//  CoreRequest.h
//  CoreResource
//
//  Created by Mike Laurence on 12/31/09.
//  Copyright 2009 Punkbot LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface CoreRequest : ASIHTTPRequest {
    id coreDelegate;
    SEL coreSelector;
}

@property (nonatomic, retain) id coreDelegate;
@property (nonatomic, assign) SEL coreSelector;

@end
