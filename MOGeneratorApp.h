// mogenerator.h
//   Copyright (c) 2006-2013 Jonathan 'Wolf' Rentzsch: http://rentzsch.com
//   Some rights reserved: http://opensource.org/licenses/mit
//   http://github.com/rentzsch/mogenerator

#import <Foundation/Foundation.h>
#import "DDCommandLineInterface.h"

@class MiscMergeEngine;

@interface MOGeneratorApp : NSObject <DDCliApplicationDelegate> {
    NSString              *pathToFolderContainingModel;
    NSString              *tempGeneratedMomFilePath;
    NSManagedObjectModel  *model;
    NSString              *configuration;
    NSString              *baseClass;
    NSString              *baseClassImport;
    NSString              *baseClassForce;
    NSString              *includem;
    NSString              *includeh;
    NSString              *templatePath;
    NSString              *outputDir;
    NSString              *machineDir;
    NSString              *humanDir;
    NSString              *templateGroup;
    BOOL                  _help;
    BOOL                  _version;
    BOOL                  _listSourceFiles;
    BOOL                  _orphaned;
    NSMutableDictionary   *templateVar;
    
    MiscMergeEngine *machineH;
    MiscMergeEngine *machineM;
    MiscMergeEngine *humanH;
    MiscMergeEngine *humanM;
    
    BOOL machineDirtied;
    int machineFilesGenerated;
    int humanFilesGenerated;
    
    NSMutableArray *humanHFiles;
    NSMutableArray *humanMFiles;
    NSMutableArray *machineHFiles;
    NSMutableArray *machineMFiles;
    
    NSMutableString *includeHFileContent;
    NSMutableString *includeMFileContent;
    
    NSString *lastGeneratedMachineMFileName;
}
@end
