//
//  NSRelationshipDescription+CollectionClassName.h
//  mogenerator
//
//  Created by Robert Gilliam on 7/13/13.
//
//

#import <CoreData/CoreData.h>

@interface NSRelationshipDescription (CollectionClassName)
- (NSString*)mutableCollectionClassName;
- (NSString*)immutableCollectionClassName;
- (BOOL)jr_isOrdered;
@end
