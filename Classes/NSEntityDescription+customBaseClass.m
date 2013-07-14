//
//  NSEntityDescription+customBaseClass.m
//  mogenerator
//
//  Created by Robert Gilliam on 7/13/13.
//
//

#import "NSEntityDescription+customBaseClass.h"
#import "Globals.h"
#import "DDCliUtil.h"
#import "NSEntityDescription+fetchedPropertiesAdditions.h"
#import "NSEntityDescription+userInfoAdditions.h"
#import "NSAttributeDescription+Typing.h"

@implementation NSEntityDescription (customBaseClass)
- (BOOL)hasCustomBaseCaseImport {
    return gCustomBaseClassImport == nil ? NO : YES;
}
- (NSString*)baseClassImport {
    return gCustomBaseClassImport;
}

- (BOOL)hasCustomClass {
    NSString *entityClassName = [self managedObjectClassName];
    BOOL result = !([entityClassName isEqualToString:@"NSManagedObject"]
                    || [entityClassName isEqualToString:@""]
                    || [entityClassName isEqualToString:gCustomBaseClass]);
    return result;
}

- (BOOL)hasSuperentity {
    NSEntityDescription *superentity = [self superentity];
    if (superentity) {
        return YES;
    }
    return NO;
}

- (BOOL)hasCustomSuperentity {
    NSString *forcedBaseClass = [self forcedCustomBaseClass];
    if (!forcedBaseClass) {
        NSEntityDescription *superentity = [self superentity];
        if (superentity) {
            return [superentity hasCustomClass] ? YES : NO;
        } else {
            return gCustomBaseClass ? YES : NO;
        }
    } else {
        return YES;
    }
}

- (NSString*)customSuperentity {
    NSString *forcedBaseClass = [self forcedCustomBaseClass];
    if (!forcedBaseClass) {
        NSEntityDescription *superentity = [self superentity];
        if (superentity) {
            return [superentity managedObjectClassName];
        } else {
            return gCustomBaseClass ? gCustomBaseClass : @"NSManagedObject";
        }
    } else {
        return forcedBaseClass;
    }
}
- (NSString*)forcedCustomBaseClass {
    NSString* userInfoCustomBaseClass = [[self userInfo] objectForKey:@"mogenerator.customBaseClass"];
    return userInfoCustomBaseClass ? userInfoCustomBaseClass : gCustomBaseClassForced;
}
/** @TypeInfo NSAttributeDescription */
- (NSArray*)noninheritedAttributes {
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSEntityDescription *superentity = [self superentity];
    if (superentity) {
        NSMutableArray *result = [[[[self attributesByName] allValues] mutableCopy] autorelease];
        [result removeObjectsInArray:[[superentity attributesByName] allValues]];
        return [result sortedArrayUsingDescriptors:sortDescriptors];
    } else {
        return [[[self attributesByName] allValues] sortedArrayUsingDescriptors:sortDescriptors];
    }
}
/** @TypeInfo NSAttributeDescription */
- (NSArray*)noninheritedAttributesSansType {
    NSArray *attributeDescriptions = [self noninheritedAttributes];
    NSMutableArray *filteredAttributeDescriptions = [NSMutableArray arrayWithCapacity:[attributeDescriptions count]];
    
    nsenumerate(attributeDescriptions, NSAttributeDescription, attributeDescription) {
        if ([[attributeDescription name] isEqualToString:@"type"]) {
            ddprintf(@"WARNING skipping 'type' attribute on %@ (%@) - see https://github.com/rentzsch/mogenerator/issues/74\n",
                     self.name, self.managedObjectClassName);
        } else {
            [filteredAttributeDescriptions addObject:attributeDescription];
        }
    }
    return filteredAttributeDescriptions;
}
/** @TypeInfo NSAttributeDescription */
- (NSArray*)noninheritedRelationships {
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSEntityDescription *superentity = [self superentity];
    if (superentity) {
        NSMutableArray *result = [[[[self relationshipsByName] allValues] mutableCopy] autorelease];
        [result removeObjectsInArray:[[superentity relationshipsByName] allValues]];
        return [result sortedArrayUsingDescriptors:sortDescriptors];
    } else {
        return [[[self relationshipsByName] allValues] sortedArrayUsingDescriptors:sortDescriptors];
    }
}
/** @TypeInfo NSEntityUserInfoDescription */
- (NSArray*)userInfoKeyValues {
	NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"key" ascending:YES]];
	NSEntityDescription *superentity = [self superentity];
	if (superentity) {
		NSMutableArray *result = [[[[self userInfoByKeys] allValues] mutableCopy] autorelease];
		[result removeObjectsInArray:[[superentity userInfoByKeys] allValues]];
		return [result sortedArrayUsingDescriptors:sortDescriptors];
	} else {
		return [[[self userInfoByKeys] allValues] sortedArrayUsingDescriptors:sortDescriptors];
	}
}
/** @TypeInfo NSFetchedPropertyDescription */
- (NSArray*)noninheritedFetchedProperties {
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSEntityDescription *superentity = [self superentity];
    if (superentity) {
        NSMutableArray *result = [[[[self fetchedPropertiesByName] allValues] mutableCopy] autorelease];
        [result removeObjectsInArray:[[superentity fetchedPropertiesByName] allValues]];
        return [result sortedArrayUsingDescriptors:sortDescriptors];
    } else {
        return [[[self fetchedPropertiesByName] allValues]  sortedArrayUsingDescriptors:sortDescriptors];
    }
}
/** @TypeInfo NSAttributeDescription */
- (NSArray*)indexedNoninheritedAttributes {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isIndexed == YES"];
    return [[self noninheritedAttributes] filteredArrayUsingPredicate:predicate];
}

#pragma mark Fetch Request support

- (NSDictionary*)fetchRequestTemplates {
    // -[NSManagedObjectModel _fetchRequestTemplatesByName] is a private method, but it's the only way to get
    //  model fetch request templates without knowing their name ahead of time. rdar://problem/4901396 asks for
    //  a public method (-[NSManagedObjectModel fetchRequestTemplatesByName]) that does the same thing.
    //  If that request is fulfilled, this code won't need to be modified thanks to KVC lookup order magic.
    //  UPDATE: 10.5 now has a public -fetchRequestTemplatesByName method.
    NSDictionary *fetchRequests = [[self managedObjectModel] valueForKey:@"fetchRequestTemplatesByName"];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[fetchRequests count]];
    nsenumerate ([fetchRequests allKeys], NSString, fetchRequestName) {
        NSFetchRequest *fetchRequest = [fetchRequests objectForKey:fetchRequestName];
        if ([fetchRequest entity] == self) {
            [result setObject:fetchRequest forKey:fetchRequestName];
        }
    }
    return result;
}

- (NSString*)_resolveKeyPathType:(NSString*)keyPath {
    NSArray *components = [keyPath componentsSeparatedByString:@"."];
    
    // Hope the set of keys in the key path consists of solely relationships. Abort otherwise
    
    NSEntityDescription *entity = self;
    nsenumerate(components, NSString, key) {
        id property = [[entity propertiesByName] objectForKey:key];
        if ([property isKindOfClass:[NSAttributeDescription class]]) {
            NSString *result = [property objectAttributeType];
            return [result substringToIndex:[result length] -1];
        } else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
            entity = [property destinationEntity];
        }
        assert(property);
    }
    
    return [entity managedObjectClassName];
}

// auxiliary function
- (BOOL)bindingsArray:(NSArray*)bindings containsVariableNamed:(NSString*)name {
    for (NSDictionary *dict in bindings) {
        if ([[dict objectForKey:@"name"] isEqual:name]) {
            return YES;
        }
    }
    return NO;
}

- (void)_processPredicate:(NSPredicate*)predicate_ bindings:(NSMutableArray*)bindings_ {
    if (!predicate_) return;
    
    if ([predicate_ isKindOfClass:[NSCompoundPredicate class]]) {
        nsenumerate([(NSCompoundPredicate*)predicate_ subpredicates], NSPredicate, subpredicate) {
            [self _processPredicate:subpredicate bindings:bindings_];
        }
    } else if ([predicate_ isKindOfClass:[NSComparisonPredicate class]]) {
        assert([[(NSComparisonPredicate*)predicate_ leftExpression] expressionType] == NSKeyPathExpressionType);
        NSExpression *lhs = [(NSComparisonPredicate*)predicate_ leftExpression];
        NSExpression *rhs = [(NSComparisonPredicate*)predicate_ rightExpression];
        switch([rhs expressionType]) {
            case NSConstantValueExpressionType:
            case NSEvaluatedObjectExpressionType:
            case NSKeyPathExpressionType:
            case NSFunctionExpressionType:
                //  Don't do anything with these.
                break;
            case NSVariableExpressionType: {
                // TODO SHOULD Handle LHS keypaths.
                
                NSString *type = nil;
                
                NSAttributeDescription *attribute = [[self attributesByName] objectForKey:[lhs keyPath]];
                if (attribute) {
                    type = [attribute objectAttributeClassName];
                } else {
                    type = [self _resolveKeyPathType:[lhs keyPath]];
                }
                type = [type stringByAppendingString:@"*"];
                // make sure that no repeated variables are entered here.
                if (![self bindingsArray:bindings_ containsVariableNamed:[rhs variable]]) {
                    [bindings_ addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [rhs variable], @"name",
                                          type, @"type",
                                          nil]];
                }
            } break;
            default:
                assert(0 && "unknown NSExpression type");
        }
    }
}
- (NSArray*)prettyFetchRequests {
    NSDictionary *fetchRequests = [self fetchRequestTemplates];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[fetchRequests count]];
    nsenumerate ([fetchRequests allKeys], NSString, fetchRequestName) {
        NSFetchRequest *fetchRequest = [fetchRequests objectForKey:fetchRequestName];
        NSMutableArray *bindings = [NSMutableArray array];
        [self _processPredicate:[fetchRequest predicate] bindings:bindings];
        [result addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                           fetchRequestName, @"name",
                           bindings, @"bindings",
                           [NSNumber numberWithBool:[bindings count] > 0], @"hasBindings",
                           [NSNumber numberWithBool:[fetchRequestName hasPrefix:@"one"]], @"singleResult",
                           nil]];
    }
    return result;
}
@end
