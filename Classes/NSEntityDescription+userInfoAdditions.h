//
//  NSEntityDescription+userInfoAdditions.h
//  mogenerator
//
//  Created by Robert Gilliam on 7/13/13.
//
//

#import <CoreData/CoreData.h>

@interface NSEntityDescription (userInfoAdditions)
- (BOOL)hasUserInfoKeys;
- (NSDictionary *)userInfoByKeys;
@end
