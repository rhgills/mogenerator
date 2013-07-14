#import <Cocoa/Cocoa.h>
#import "MyBaseClass.h"
#import "MOs/ParentMO.h"
#import "MOs/ChildMO.h"
#import "MyProtocolImpl.h"

#if __has_feature(objc_arc)
    #define autorelease self
#endif

NSManagedObjectContext *createManagedObjectContext();
void testManagedObjectCreationAndPropertyAndRelationship(NSManagedObjectContext *moc);
ParentMO *newParentMONamedAndVerifyPropertyAndAssertNoChildren(NSString *n, NSManagedObjectContext *moc);
ChildMO *newChildMONamedAndVerifyProperty(NSString *n, NSManagedObjectContext *moc);
void assertParentMOsCanHaveChildrenAdded(NSArray *parents, NSArray *children);
void testCanSetAProtocolImplOnAPropertyConformingToTheProtocol(NSManagedObjectContext *moc);
void assertCanSave(NSManagedObjectContext *moc);



int main(int argc, char *argv[]) {
    @autoreleasepool {
        NSManagedObjectContext *moc = createManagedObjectContext();
        testManagedObjectCreationAndPropertyAndRelationship(moc);
        testCanSetAProtocolImplOnAPropertyConformingToTheProtocol(moc);
        assertCanSave(moc);
    }
    
    puts("success");
    return 0;
}




NSManagedObjectContext *createManagedObjectContext() {
    NSURL *modelURL = [NSURL fileURLWithPath:@"test.mom"];
    assert(modelURL);
    
    NSManagedObjectModel *model = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] autorelease];
    assert(model);
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model] autorelease];
    assert(persistentStoreCoordinator);
    
    NSError *inMemoryStoreError = nil;
    NSPersistentStore *persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                                                  configuration:nil
                                                                                            URL:nil
                                                                                        options:nil
                                                                                          error:&inMemoryStoreError];
    
    assert(persistentStore);
    assert(!inMemoryStoreError);
    
    NSManagedObjectContext *moc = [[[NSManagedObjectContext alloc] init] autorelease];
    [moc setPersistentStoreCoordinator:persistentStoreCoordinator];
    assert(moc);
    
    return moc;
}

void testManagedObjectCreationAndPropertyAndRelationship(NSManagedObjectContext *moc) {
    ParentMO *homer = newParentMONamedAndVerifyPropertyAndAssertNoChildren(@"homer", moc);
    ParentMO *marge = newParentMONamedAndVerifyPropertyAndAssertNoChildren(@"marge", moc);
    
    ChildMO *bart = newChildMONamedAndVerifyProperty(@"bart", moc);
    ChildMO *lisa = newChildMONamedAndVerifyProperty(@"lisa", moc);
    
    assertParentMOsCanHaveChildrenAdded(@[homer, marge], @[bart, lisa]);
}

ParentMO *newParentMONamedAndVerifyPropertyAndAssertNoChildren(NSString *n, NSManagedObjectContext *moc) {
    ParentMO *mo = [ParentMO insertInManagedObjectContext:moc];
    mo.humanName = mo.parentName = n;
    [mo setIvar:1.0];
    NSCAssert([mo ivar] == 1.0, nil);
    NSCAssert([mo.children count] == 0, nil);
    return mo;
}

ChildMO *newChildMONamedAndVerifyProperty(NSString *n, NSManagedObjectContext *moc) {
    ChildMO *mo = [ChildMO insertInManagedObjectContext:moc];
    mo.humanName = mo.childName = n;
    [mo setIvar:1.0];
    NSCAssert([mo ivar] == 1.0, nil);
    return mo;
}

void assertParentMOsCanHaveChildrenAdded(NSArray *parents, NSArray *children) {
    for (ParentMO *aParent in parents) {
        for (ChildMO *aChild in children) {
            [aParent addChildrenObject:aChild];
        }
        
        NSCAssert([aParent.children count] == 2, nil);
    }
}

void testCanSetAProtocolImplOnAPropertyConformingToTheProtocol(NSManagedObjectContext *moc) {
    ParentMO *protocolMO = [ParentMO insertInManagedObjectContext:moc];
    protocolMO.myTransformableWithProtocol = [MyProtocolImpl new];
}

void assertCanSave(NSManagedObjectContext *moc) {
    NSError *saveError = nil;
    BOOL saveSuccess = [moc save:&saveError];
    assert(saveSuccess);
    assert(!saveError);
}
