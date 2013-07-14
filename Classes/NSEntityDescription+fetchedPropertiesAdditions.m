//
//  NSEntityDescription+fetchedPropertiesAdditions.m
//  mogenerator
//
//  Created by Robert Gilliam on 7/13/13.
//
//

#import "NSEntityDescription+fetchedPropertiesAdditions.h"
#import "nsenumerate.h"

@implementation NSEntityDescription (fetchedPropertiesAdditions)
- (NSDictionary*)fetchedPropertiesByName {
    NSMutableDictionary *fetchedPropertiesByName = [NSMutableDictionary dictionary];
    
    nsenumerate ([self properties], NSPropertyDescription, property) {
        if ([property isKindOfClass:[NSFetchedPropertyDescription class]]) {
            [fetchedPropertiesByName setObject:property forKey:[property name]];
        }
    }
    
    return fetchedPropertiesByName;
}
@end
