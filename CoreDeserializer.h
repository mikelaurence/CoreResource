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
    id source;
    NSString *sourceString;
    NSString *format;
    CoreManager *coreManager;
    Class resourceClass;
    
    // Target
    id target;
    SEL action;
}

@property (nonatomic, retain) id source;
@property (nonatomic, retain) NSString* format;
@property (nonatomic, retain) CoreManager *coreManager;
@property (nonatomic, assign) Class resourceClass;

@property (nonatomic, retain) id target;
@property (nonatomic, assign) SEL action;

#pragma mark -
#pragma mark Format determination
- (NSString*) formatFromHeader:(NSString*)header inDictionary:(SEL)dictionarySelector;
- (NSString*) allowedFormatsFromString:(NSString*)string;


@end
