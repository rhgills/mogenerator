//
//  NSEntityDescription+fetchedPropertiesAdditions.h
//  mogenerator
//
//  Created by Robert Gilliam on 7/13/13.
//
//

#import <CoreData/CoreData.h>

@interface NSEntityDescription (fetchedPropertiesAdditions)
- (NSDictionary*)fetchedPropertiesByName;
@end

