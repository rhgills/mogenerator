//
//  NSRelationshipDescription+CollectionClassName.m
//  mogenerator
//
//  Created by Robert Gilliam on 7/13/13.
//
//

#import "NSRelationshipDescription+CollectionClassName.h"

@implementation NSRelationshipDescription (CollectionClassName)

- (NSString*)mutableCollectionClassName {
    return [self jr_isOrdered] ? @"NSMutableOrderedSet" : @"NSMutableSet";
}

- (NSString*)immutableCollectionClassName {
    return [self jr_isOrdered] ? @"NSOrderedSet" : @"NSSet";
}

- (BOOL)jr_isOrdered {
    if ([self respondsToSelector:@selector(isOrdered)]) {
        return [self isOrdered];
    } else {
        return NO;
    }
}

@end
