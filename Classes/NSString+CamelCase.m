//
//  NSString+CamelCase.m
//  mogenerator
//
//  Created by Robert Gilliam on 7/13/13.
//
//

#import "NSString+CamelCase.h"
#import "NSString+MiscAdditions.h"
#import "FoundationAdditions.h"

@implementation NSString (CamelCase)
- (NSString*)camelCaseString {
    NSArray *lowerCasedWordArray = [[self wordArray] arrayByMakingObjectsPerformSelector:@selector(lowercaseString)];
    NSUInteger wordIndex = 1, wordCount = [lowerCasedWordArray count];
    NSMutableArray *camelCasedWordArray = [NSMutableArray arrayWithCapacity:wordCount];
    if (wordCount)
        [camelCasedWordArray addObject:[lowerCasedWordArray objectAtIndex:0]];
    for (; wordIndex < wordCount; wordIndex++) {
        [camelCasedWordArray addObject:[[lowerCasedWordArray objectAtIndex:wordIndex] initialCapitalString]];
    }
    return [camelCasedWordArray componentsJoinedByString:@""];
}
@end
