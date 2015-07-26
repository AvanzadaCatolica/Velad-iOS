//
//  VLDMigrationController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 25/07/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDMigrationController.h"
#import <Realm/Realm.h>
#import "VLDNote.h"

static NSUInteger const kSchemaVersion = 1;

@implementation VLDMigrationController

- (void)performMigration {
    [RLMRealm setSchemaVersion:kSchemaVersion
                forRealmAtPath:[RLMRealm defaultRealmPath]
            withMigrationBlock:^(RLMMigration *migration, uint64_t oldSchemaVersion) {
                if (oldSchemaVersion < 1) {
                    [migration enumerateObjects:VLDNote.className
                                          block:^(RLMObject *oldObject, RLMObject *newObject) {
                                              newObject[@"text"] = [newObject[@"text"] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                                          }];
                }
            }];
}

@end