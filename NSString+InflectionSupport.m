//
//  NSString+InflectionSupport.m
//  
//
//  Created by Ryan Daigle on 7/31/08.
//  Copyright 2008 yFactorial, LLC. All rights reserved.
//

#import "NSString+InflectionSupport.h"

@implementation NSString (InflectionSupport)

static NSMutableDictionary *cachedCamelized;

- (NSCharacterSet *)capitals {
	return [NSCharacterSet uppercaseLetterCharacterSet];
}

- (NSString *)deCamelizeWith:(NSString *)delimiter {
	
	unichar *buffer = calloc([self length], sizeof(unichar));
	[self getCharacters:buffer ];
	NSMutableString *underscored = [NSMutableString string];
	
	NSString *currChar;
	for (int i = 0; i < [self length]; i++) {
		currChar = [NSString stringWithCharacters:buffer+i length:1];
		if([[self capitals] characterIsMember:buffer[i]]) {
			[underscored appendFormat:@"%@%@", delimiter, [currChar lowercaseString]];
		} else {
			[underscored appendString:currChar];
		}
	}
	
	free(buffer);
	return underscored;
}
	

- (NSString *)dasherize {
	return [self deCamelizeWith:@"-"];
}

- (NSString *)underscore {
	return [self deCamelizeWith:@"_"];
}

- (NSCharacterSet *)camelcaseDelimiters {
	return [NSCharacterSet characterSetWithCharactersInString:@"-_"];
}

- (NSString *)camelize {
	
	unichar *buffer = calloc([self length], sizeof(unichar));
	[self getCharacters:buffer ];
	NSMutableString *underscored = [NSMutableString string];
	
	BOOL capitalizeNext = NO;
	NSCharacterSet *delimiters = [self camelcaseDelimiters];
	for (int i = 0; i < [self length]; i++) {
		NSString *currChar = [NSString stringWithCharacters:buffer+i length:1];
		if([delimiters characterIsMember:buffer[i]]) {
			capitalizeNext = YES;
		} else {
			if(capitalizeNext) {
				[underscored appendString:[currChar uppercaseString]];
				capitalizeNext = NO;
			} else {
				[underscored appendString:currChar];
			}
		}
	}
	
	free(buffer);
	return underscored;
}

- (NSString*)camelizeCached {
    if (cachedCamelized == nil)
        cachedCamelized = [[NSMutableDictionary dictionary] retain];
    else {
        NSString* cached = [cachedCamelized objectForKey:self];
        if (cached != nil)
            return cached;
    }
    
    NSString* camelized = [self camelize];
    [cachedCamelized setObject:camelized forKey:self];
    return camelized;
}

- (NSString *)titleize {
	NSArray *words = [self componentsSeparatedByString:@" "];
	NSMutableString *output = [NSMutableString string];
	for (NSString *word in words) {
		[output appendString:[[word substringToIndex:1] uppercaseString]];
		[output appendString:[[word substringFromIndex:1] lowercaseString]];
		[output appendString:@" "];
	}
	return [output substringToIndex:[self length]];
}

- (NSString *)decapitalize {
    return [[[self substringToIndex:1] lowercaseString] stringByAppendingString:[self substringFromIndex:1]];
}

- (NSString *)toClassName {
	NSString *result = [self camelize];
	return [result stringByReplacingCharactersInRange:NSMakeRange(0,1) 
										 withString:[[result substringWithRange:NSMakeRange(0,1)] uppercaseString]];
}

- (NSString *)singularize {
    return [self hasSuffix:@"s"] ? [self substringToIndex:[self length] - 1] : self;
}

- (NSString *)pluralize {
    return [self hasSuffix:@"s"] ? self : [self stringByAppendingString:@"s"];
}

@end
