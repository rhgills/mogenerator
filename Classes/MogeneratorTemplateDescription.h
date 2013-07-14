//
//  MogeneratorTemplateDesc.h
//  mogenerator
//
//  Created by Robert Gilliam on 7/13/13.
//
//

#import <Foundation/Foundation.h>

@interface MogeneratorTemplateDescription : NSObject {
    NSString *templateName;
    NSString *templatePath;
}
- (id)initWithName:(NSString*)name_ path:(NSString*)path_;
- (NSString*)templateName;
- (void)setTemplateName:(NSString*)name_;
- (NSString*)templatePath;
- (void)setTemplatePath:(NSString*)path_;
@end
