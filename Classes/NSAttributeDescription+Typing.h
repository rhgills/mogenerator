//
//  NSAttributeDescription+Typing.h
//  mogenerator
//
//  Created by Robert Gilliam on 7/13/13.
//
//

#import <CoreData/CoreData.h>

@interface NSAttributeDescription (Typing)
- (BOOL)hasScalarAttributeType;
- (NSString*)scalarAttributeType;
- (NSString*)scalarAccessorMethodName;
- (NSString*)scalarFactoryMethodName;
- (BOOL)hasDefinedAttributeType;
- (NSArray*)objectAttributeTransformableProtocols;
- (BOOL)hasAttributeTransformableProtocols;
- (NSString*)objectAttributeClassName;
- (NSString*)objectAttributeType;
- (BOOL)hasTransformableAttributeType;
- (BOOL)isReadonly;
@end
