//
//  NSEntityDescription+userInfoAdditions.m
//  mogenerator
//
//  Created by Robert Gilliam on 7/13/13.
//
//

#import "NSEntityDescription+userInfoAdditions.h"

@implementation NSEntityDescription (userInfoAdditions)
- (BOOL)hasUserInfoKeys {
	return ([self.userInfo count] > 0);
}

- (NSDictionary *)userInfoByKeys
{
	NSMutableDictionary *userInfoByKeys = [NSMutableDictionary dictionary];
    
	for (NSString *key in self.userInfo)
		[userInfoByKeys setObject:[NSDictionary dictionaryWithObjectsAndKeys:key, @"key", [self.userInfo objectForKey:key], @"value", nil] forKey:key];
    
	return userInfoByKeys;
}
@end
