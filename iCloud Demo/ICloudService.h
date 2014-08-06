//
//  ICloudService.h
//  iCloud Demo
//
//  Created by Florian BUREL on 05/08/2014.
//  Copyright (c) 2014 Florian BUREL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NoteDocument;

@interface ICloudService : NSObject



+ (instancetype)sharedInstance;

- (void) retrieveUserAccountToken:(void(^)(BOOL hasAccount, BOOL accountHasChanged))completion;


// Read the list of notes
- (void) startMonitoringCloud;
- (void) stopMonitoringCloud;

- (void)insertNewDocument:(void (^)(NoteDocument *))completion;

- (BOOL) iCloudIsAvailable;

@end
