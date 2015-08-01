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
#import "VLDWeekday.h"
#import "VLDAlert.h"
#import "VLDRecord.h"

@interface VLDMigrationController ()

- (BOOL)isDatabaseSeeded;

@end

static NSUInteger const kSchemaVersion = 1;
static NSString * const kIsDatabaseSeeded = @"VLDIsDatabaseSeeded";
static NSString * const kHasPerformedCurrentHardMigration = @"VLDHardMigration_v1";

@implementation VLDMigrationController

- (void)performMigration {
    [RLMRealm setSchemaVersion:kSchemaVersion
                forRealmAtPath:[RLMRealm defaultRealmPath]
            withMigrationBlock:^(RLMMigration *migration, uint64_t oldSchemaVersion) {
            }];
}

- (void)performHardMigration {
    if ([self hasPerformedCurrentHardMigration]) {
        return;
    }
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[RLMRealm defaultRealmPath] error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsDatabaseSeeded];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHasPerformedCurrentHardMigration];
}

- (void)deleteAllData {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    [realm deleteObjects:[VLDWeekDay allObjects]];
    [realm deleteObjects:[VLDAlert allObjects]];
    [realm deleteObjects:[VLDBasicPoint allObjects]];
    [realm deleteObjects:[VLDGroup allObjects]];
    [realm deleteObjects:[VLDRecord allObjects]];
    
    [realm commitWriteTransaction];
}

- (void)seedDatabaseIfNeeded {
    if ([self isDatabaseSeeded]) {
        return;
    }
    [self seedDatabase];
}

- (void)seedDatabase {
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

#pragma mark - Private methods

- (BOOL)isDatabaseSeeded {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kIsDatabaseSeeded];
}

- (BOOL)hasPerformedCurrentHardMigration {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kHasPerformedCurrentHardMigration];
}

@end
