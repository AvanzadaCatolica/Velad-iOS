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
#import "VLDGroup.h"

@interface VLDMigrationController ()

+ (BOOL)isDatabaseSeedNeeded;
+ (void)seedDatabase;

@end

static NSUInteger const kSchemaVersion = 4;
static NSString * const kIsDatabaseSeeded = @"VLDIsDatabaseSeeded";

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
                if (oldSchemaVersion < 3) {
                    VLDGroup *group = [[VLDGroup alloc] init];
                    group.name = @"General";
                    group.order = 0;
                    [migration enumerateObjects:VLDBasicPoint.className
                                          block:^(RLMObject *oldObject, RLMObject *newObject) {
                                              [group.basicPoints addObject:newObject];
                                          }];
                }
                if (oldSchemaVersion < 4) {
                    [migration enumerateObjects:VLDBasicPoint.className
                                          block:^(RLMObject *oldObject, RLMObject *newObject) {
                                              
                                          }];
                }
            }];
}

#pragma mark - Private methods

+ (BOOL)isDatabaseSeedNeeded {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kIsDatabaseSeeded];
}

+ (void)seedDatabase {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"es"];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    
    VLDBasicPoint *basicPoint;
    VLDGroup *group = [[VLDGroup alloc] init];
    group.name = @"General";
    group.order = 0;
    [realm addObject:group];
    
    basicPoint = [[VLDBasicPoint alloc] init];
    basicPoint.UUID = [[NSUUID UUID] UUIDString];
    basicPoint.name = @"Oración";
    basicPoint.descriptionText = @"";
    basicPoint.enabled = YES;
    for (NSString *weekdaySymbol in [dateFormatter weekdaySymbols]) {
        VLDWeekDay *weekday = [[VLDWeekDay alloc] init];
        weekday.name = weekdaySymbol;
        [basicPoint.weekDays addObject:weekday];
    }
    [realm addObject:basicPoint];
    [group.basicPoints addObject:basicPoint];
    
    basicPoint = [[VLDBasicPoint alloc] init];
    basicPoint.UUID = [[NSUUID UUID] UUIDString];
    basicPoint.name = @"Abnegación";
    basicPoint.descriptionText = @"";
    basicPoint.enabled = YES;
    for (NSString *weekdaySymbol in [dateFormatter weekdaySymbols]) {
        VLDWeekDay *weekday = [[VLDWeekDay alloc] init];
        weekday.name = weekdaySymbol;
        [basicPoint.weekDays addObject:weekday];
    }
    [realm addObject:basicPoint];
    [group.basicPoints addObject:basicPoint];
    
    basicPoint = [[VLDBasicPoint alloc] init];
    basicPoint.UUID = [[NSUUID UUID] UUIDString];
    basicPoint.name = @"Eucaristía";
    basicPoint.descriptionText = @"";
    basicPoint.enabled = YES;
    for (NSString *weekdaySymbol in [dateFormatter weekdaySymbols]) {
        VLDWeekDay *weekday = [[VLDWeekDay alloc] init];
        weekday.name = weekdaySymbol;
        [basicPoint.weekDays addObject:weekday];
    }
    [realm addObject:basicPoint];
    [group.basicPoints addObject:basicPoint];
    
    basicPoint = [[VLDBasicPoint alloc] init];
    basicPoint.UUID = [[NSUUID UUID] UUIDString];
    basicPoint.name = @"Rosario";
    basicPoint.descriptionText = @"";
    basicPoint.enabled = YES;
    for (NSString *weekdaySymbol in [dateFormatter weekdaySymbols]) {
        VLDWeekDay *weekday = [[VLDWeekDay alloc] init];
        weekday.name = weekdaySymbol;
        [basicPoint.weekDays addObject:weekday];
    }
    [realm addObject:basicPoint];
    [group.basicPoints addObject:basicPoint];
    
    basicPoint = [[VLDBasicPoint alloc] init];
    basicPoint.UUID = [[NSUUID UUID] UUIDString];
    basicPoint.name = @"Lectura";
    basicPoint.descriptionText = @"";
    basicPoint.enabled = YES;
    for (NSString *weekdaySymbol in [dateFormatter weekdaySymbols]) {
        VLDWeekDay *weekday = [[VLDWeekDay alloc] init];
        weekday.name = weekdaySymbol;
        [basicPoint.weekDays addObject:weekday];
    }
    [realm addObject:basicPoint];
    [group.basicPoints addObject:basicPoint];
    
    [realm commitWriteTransaction];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsDatabaseSeeded];
}

@end
