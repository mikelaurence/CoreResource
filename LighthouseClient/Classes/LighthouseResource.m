//
//  LighthouseResource.m
//  LighthouseClient
//
//  Created by Mike Laurence on 3/6/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import "LighthouseResource.h"


@implementation LighthouseResource

+ (NSString*) localNameForRemoteField:(NSString*)field {
    return [field camelize];
}

+ (NSString*) remoteNameForLocalField:(NSString*)field {
    return [field deCamelizeWith:@"_"];
}

// Remove nesting from JSON response
+ (NSArray*) dataCollectionFromDeserializedCollection:(NSMutableArray*)deserializedCollection {
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:[deserializedCollection count]];
    for (NSDictionary* dict in deserializedCollection)
        [array addObject:[[dict allValues] objectAtIndex:0]];
    
    return array;
}

@end
