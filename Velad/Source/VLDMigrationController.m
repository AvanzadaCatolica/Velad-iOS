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
#import "VLDBasicPoint.h"

static NSUInteger const kSchemaVersion = 2;

@implementation VLDMigrationController

- (void)performMigration {
    [RLMRealm setSchemaVersion:kSchemaVersion
                forRealmAtPath:[RLMRealm defaultRealmPath]
            withMigrationBlock:^(RLMMigration *migration, uint64_t oldSchemaVersion) {
                if (oldSchemaVersion < 1) {
                    [migration enumerateObjects:VLDNote.className
                                          block:^(RLMObject *oldObject, RLMObject *newObject) {
                                              newObject[@"text"] = [oldObject[@"text"] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                                          }];
                }
                if (oldSchemaVersion < 2) {
                    [migration enumerateObjects:VLDBasicPoint.className
                                          block:^(RLMObject *oldObject, RLMObject *newObject) {
                                              NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                              dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"es"];
                                              for (NSString *weekdaySymbol in [dateFormatter weekdaySymbols]) {
                                                  VLDWeekDay *weekday = [[VLDWeekDay alloc] init];
                                                  weekday.name = weekdaySymbol;
                                                  [newObject[@"weekDays"] addObject:weekday];
                                              }
                                          }];
                }
            }];
}

- (void)orderingFix {
    RLMResults *basicPoints = [VLDBasicPoint basicPoints];
    int order = 0;
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    for (VLDBasicPoint *basicPoint in basicPoints) {
        basicPoint.order = order;
        order++;
    }
    [realm commitWriteTransaction];
}

@end
