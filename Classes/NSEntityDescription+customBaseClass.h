//
//  NSEntityDescription+customBaseClass.h
//  mogenerator
//
//  Created by Robert Gilliam on 7/13/13.
//
//

#import <CoreData/CoreData.h>

@interface NSEntityDescription (customBaseClass)
- (BOOL)hasCustomClass;
- (BOOL)hasSuperentity;
- (BOOL)hasCustomSuperentity;
- (NSString*)customSuperentity;
- (NSString*)forcedCustomBaseClass;
- (void)_processPredicate:(NSPredicate*)predicate_ bindings:(NSMutableArray*)bindings_;
- (NSArray*)prettyFetchRequests;
@end
