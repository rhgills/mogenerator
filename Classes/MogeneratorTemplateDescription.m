//
//  MogeneratorTemplateDesc.m
//  mogenerator
//
//  Created by Robert Gilliam on 7/13/13.
//
//

#import "MogeneratorTemplateDescription.h"

@implementation MogeneratorTemplateDescription

- (id)initWithName:(NSString*)name_ path:(NSString*)path_ {
    self = [super init];
    if (self) {
        templateName = [name_ retain];
        templatePath = [path_ retain];
    }
    return self;
}

- (void)dealloc {
    [templateName release];
    [templatePath release];
    [super dealloc];
}

- (NSString*)templateName {
    return templateName;
}

- (void)setTemplateName:(NSString*)name_ {
    if (templateName != name_) {
        [templateName release];
        templateName = [name_ retain];
    }
}

- (NSString*)templatePath {
    return templatePath;
}

- (void)setTemplatePath:(NSString*)path_ {
    if (templatePath != path_) {
        [templatePath release];
        templatePath = [path_ retain];
    }
}

@end
