//
//  NSAttributeDescription+Typing.m
//  mogenerator
//
//  Created by Robert Gilliam on 7/13/13.
//
//

#import "NSAttributeDescription+Typing.h"

@implementation NSAttributeDescription (Typing)
- (BOOL)hasScalarAttributeType {
    switch ([self attributeType]) {
        case NSInteger16AttributeType:
        case NSInteger32AttributeType:
        case NSInteger64AttributeType:
        case NSDoubleAttributeType:
        case NSFloatAttributeType:
        case NSBooleanAttributeType:
            return YES;
            break;
        default:
            return NO;
    }
}
- (NSString*)scalarAttributeType {
    switch ([self attributeType]) {
        case NSInteger16AttributeType:
            return @"int16_t";
            break;
        case NSInteger32AttributeType:
            return @"int32_t";
            break;
        case NSInteger64AttributeType:
            return @"int64_t";
            break;
        case NSDoubleAttributeType:
            return @"double";
            break;
        case NSFloatAttributeType:
            return @"float";
            break;
        case NSBooleanAttributeType:
            return @"BOOL";
            break;
        default:
            return nil;
    }
}
- (NSString*)scalarAccessorMethodName {
    switch ([self attributeType]) {
        case NSInteger16AttributeType:
            return @"shortValue";
            break;
        case NSInteger32AttributeType:
            return @"intValue";
            break;
        case NSInteger64AttributeType:
            return @"longLongValue";
            break;
        case NSDoubleAttributeType:
            return @"doubleValue";
            break;
        case NSFloatAttributeType:
            return @"floatValue";
            break;
        case NSBooleanAttributeType:
            return @"boolValue";
            break;
        default:
            return nil;
    }
}
- (NSString*)scalarFactoryMethodName {
    switch ([self attributeType]) {
        case NSInteger16AttributeType:
            return @"numberWithShort:";
            break;
        case NSInteger32AttributeType:
            return @"numberWithInt:";
            break;
        case NSInteger64AttributeType:
            return @"numberWithLongLong:";
            break;
        case NSDoubleAttributeType:
            return @"numberWithDouble:";
            break;
        case NSFloatAttributeType:
            return @"numberWithFloat:";
            break;
        case NSBooleanAttributeType:
            return @"numberWithBool:";
            break;
        default:
            return nil;
    }
}
- (BOOL)hasDefinedAttributeType {
    return [self attributeType] != NSUndefinedAttributeType;
}
- (NSString*)objectAttributeClassName {
    NSString *result = nil;
    if ([self hasTransformableAttributeType]) {
        result = [[self userInfo] objectForKey:@"attributeValueClassName"];
        if (!result) {
            result = @"NSObject";
        }
    } else {
        result = [self attributeValueClassName];
    }
    return result;
}
- (NSArray*)objectAttributeTransformableProtocols {
    if ([self hasAttributeTransformableProtocols]) {
        NSString *protocolsString = [[self userInfo] objectForKey:@"attributeTransformableProtocols"];
        NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@", "];
        NSMutableArray *protocols = [NSMutableArray arrayWithArray:[protocolsString componentsSeparatedByCharactersInSet:removeCharSet]];
        [protocols removeObject:@""];
        return protocols;
    }
    return nil;
}
- (BOOL)hasAttributeTransformableProtocols {
    return [self hasTransformableAttributeType] && [[self userInfo] objectForKey:@"attributeTransformableProtocols"];
}
- (NSString*)objectAttributeType {
    NSString *result = [self objectAttributeClassName];
    if ([result isEqualToString:@"Class"]) {
        // `Class` (don't append asterisk).
    } else if ([result rangeOfString:@"<"].location != NSNotFound) {
        // `id<Protocol1,Protocol2>` (don't append asterisk).
    } else if ([result isEqualToString:@"NSObject"]) {
        result = @"id";
    } else {
        result = [result stringByAppendingString:@"*"]; // Make it a pointer.
    }
    return result;
}
- (BOOL)hasTransformableAttributeType {
    return ([self attributeType] == NSTransformableAttributeType);
}

- (BOOL)isReadonly {
    NSString *readonlyUserinfoValue = [[self userInfo] objectForKey:@"mogenerator.readonly"];
    if (readonlyUserinfoValue != nil) {
        return YES;
    }
    return NO;
}

@end
