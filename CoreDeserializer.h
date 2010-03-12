//
//  CoreDeserializer.h
//  Core Resource
//
//  Created by Mike Laurence on 3/11/10.
//  Copyright 2010 Mike Laurence.
//

#import <Foundation/Foundation.h>
#import "CoreManager.h"


@interface CoreDeserializer : NSOperation {
    Class resourceClass;
    NSString* json;
    id target;
    SEL action;
    
    CoreManager *coreManager;
}

@property (nonatomic, assign) Class resourceClass;
@property (nonatomic, retain) NSString* json;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

@end
