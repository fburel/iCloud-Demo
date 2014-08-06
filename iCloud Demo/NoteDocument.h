//
//  FBDocument.h
//  iCloud Demo
//
//  Created by Florian BUREL on 05/08/2014.
//  Copyright (c) 2014 Florian BUREL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteDocument : UIDocument

@property (strong, nonatomic) NSString * text;
@property (strong, nonatomic) NSDate * lastUpdate;

@end



