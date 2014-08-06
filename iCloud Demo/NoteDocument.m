//
//  FBDocument.m
//  iCloud Demo
//
//  Created by Florian BUREL on 05/08/2014.
//  Copyright (c) 2014 Florian BUREL. All rights reserved.
//

#import "NoteDocument.h"

@implementation NoteDocument

#define kNoteDocumentStorageText @"fr.matelli.noteDocument.text"
#define kNoteDocumentStorageTimestamp @"fr.matelli.noteDocument.timestamp"


- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
 
    if(contents)
    {
        // Deserialize
        NSDictionary * serializedDocument = [NSPropertyListSerialization propertyListWithData:contents
                                                                                      options:NSPropertyListImmutable
                                                                                       format:NULL
                                                                                        error:nil];
        self.text = serializedDocument[kNoteDocumentStorageText];
        self.lastUpdate = serializedDocument[kNoteDocumentStorageTimestamp];

        
    }
    
    return true;
}


- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    // Serialization
    NSDictionary * serializedDocument = @{
                                          kNoteDocumentStorageText : self.text,
                                          kNoteDocumentStorageTimestamp : self.lastUpdate
                                          };
    
    return [NSPropertyListSerialization dataWithPropertyList:serializedDocument
                                                      format:NSPropertyListBinaryFormat_v1_0
                                                     options:0
                                                       error:nil];
}


@end
