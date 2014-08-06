//
//  ICloudService.m
//  iCloud Demo
//
//  Created by Florian BUREL on 05/08/2014.
//  Copyright (c) 2014 Florian BUREL. All rights reserved.
//

#import "ICloudService.h"
#import "NoteDocument.h"



@interface ICloudService ()

@property (strong, nonatomic) NSMetadataQuery * documentQuery;

@end



@implementation ICloudService


+ (instancetype)sharedInstance {
    static id __SharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        __SharedInstance = [[self alloc] init];
        
        // Ecoute la notification emise sur changement de compte dans les reglage de l'appareil
        id center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(accountDidChange)
                       name:NSUbiquityIdentityDidChangeNotification
                     object:nil];
        
    });
    return __SharedInstance;
}



- (void) retrieveUserAccountToken:(void(^)(BOOL hasAccount, BOOL accountHasChanged))completion
{
    
    // Récupere le token
    id token = [[NSFileManager defaultManager] ubiquityIdentityToken];
    
    if(!token)
    {
        completion(NO, NO);
    }
    else if([token isEqual:[self storedToken]]) // Utiliser isEqual: pour comparer 2 token
    {
        completion(YES, NO);
    }
    else
    {
        [self setStoredToken:token]; // Cacher le token pour pouvoir le comparer prochainement
        completion(YES, YES);
    }
    
    

    
}

- (void) accountDidChange
{
    NSLog(@"Account did change");
}


#pragma mark - token storage

#define kIcloudServiceTokenStorage  @"fr.matelli.icloudService.token"

- (id) storedToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kIcloudServiceTokenStorage];
}

- (void) setStoredToken:(id)token
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kIcloudServiceTokenStorage];
    [[NSUserDefaults standardUserDefaults]setObject:token forKey:kIcloudServiceTokenStorage];
}

- (BOOL)iCloudIsAvailable
{
    NSURL *ubiq = [[NSFileManager defaultManager]
                   URLForUbiquityContainerIdentifier:nil];
    return ubiq != nil;
}

#pragma mark - Getting the url for the ubiquity container


- (void) retrieveIcloudContainerURL:(void(^)(NSURL * urlForIcloudContainer))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id container = [[NSFileManager defaultManager]URLForUbiquityContainerIdentifier:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion)
                completion(container);
        });
    });
}

- (void) allNotes:(void(^)(NSArray * notesURL))completion
{
    
}


- (void)insertNewDocument:(void (^)(NoteDocument *))completion
{
    NSString * documentName = [self generateRadomFileName];
    
    [self retrieveIcloudContainerURL:^(NSURL *urlForIcloudContainer) {
        
        NSURL * fileURL = [urlForIcloudContainer URLByAppendingPathComponent:documentName
                                                                 isDirectory:NO];
        
        NoteDocument * document = [[NoteDocument alloc]initWithFileURL:fileURL];
        
        [document saveToURL:fileURL
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              completion(document);
          }];
    }];
    
}



- (NSString *) generateRadomFileName
{
    NSString * timeStamp = [[NSDate date] description];
    NSString * randomNumber = [@(arc4random() % 100) description];
    return [NSString stringWithFormat:@"%@_%@.not", timeStamp, randomNumber];
}

#pragma mark - monitoriung cloud acitivties

- (NSMetadataQuery *)documentQuery
{
    if(!_documentQuery)
    {
        
        _documentQuery = [[NSMetadataQuery alloc] init];
        
        // Search documents subdir only
        [_documentQuery setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
        
        // Recherche tout les documents .not
        NSString * filePattern = [NSString stringWithFormat:@"*.%@", @"not"];
        [_documentQuery setPredicate:[NSPredicate predicateWithFormat:@"%K LIKE %@",
                                      NSMetadataItemFSNameKey, filePattern]];
        

    }
    return _documentQuery;
    
}


- (void) startMonitoringCloud
{
    [self stopMonitoringCloud];
    
    [self.documentQuery startQuery];
}

- (void) stopMonitoringCloud
{
    [self.documentQuery stopQuery];
    self.documentQuery  = nil;
}

@end


























