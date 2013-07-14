//
//  NSManagedObjectModel+entitiesWithACustomSubclassVerbose.h
//  mogenerator
//
//  Created by Robert Gilliam on 7/13/13.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectModel (entitiesWithACustomSubclassVerbose)
- (NSArray*)entitiesWithACustomSubclassInConfiguration:(NSString*)configuration_ verbose:(BOOL)verbose_;
@end
