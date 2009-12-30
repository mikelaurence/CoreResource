//
//  CoreUtils.h
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

@interface CoreUtils : NSObject {
}

+ (NSArray*) sortDescriptorsFromString:(NSString*)string;
+ (NSURL*) URLFromSite:(NSString*)site andParameters:(id)parameters;

@end
