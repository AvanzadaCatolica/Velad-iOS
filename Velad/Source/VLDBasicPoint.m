//
//  VLDBasicPoint.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDBasicPoint.h"
#import <Realm/Realm.h>

@interface VLDBasicPoint ()

+ (BOOL)isDatabaseSeedNeeded;
+ (void)seedDatabase;

@end

static NSString * const kIsDatabaseSeeded = @"VLDIsDatabaseSeeded";

@implementation VLDBasicPoint

#pragma makr - Public methods

+ (RLMResults *)basicPoints {
    RLMResults *results = [[VLDBasicPoint objectsWhere:@"enabled == YES"] sortedResultsUsingProperty:@"order" ascending:YES];
    if (results.count == 0 && ![self isDatabaseSeedNeeded]) {
        [self seedDatabase];
        return [self basicPoints];
    }
    return results;
}

#pragma mark - Private methods

+ (BOOL)isDatabaseSeedNeeded {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kIsDatabaseSeeded];
}

+ (void)seedDatabase {
    RLMRealm *realm = [RLMRealm defaultRealm];
    VLDBasicPoint *basicPoint;
    
    [realm beginWriteTransaction];
    
    basicPoint = [[VLDBasicPoint alloc] init];
    basicPoint.name = @"Oración";
    basicPoint.descriptionText = @"";
    basicPoint.order = 0;
    basicPoint.enabled = YES;
    [realm addObject:basicPoint];
    
    basicPoint = [[VLDBasicPoint alloc] init];
    basicPoint.name = @"Abnegación";
    basicPoint.descriptionText = @"";
    basicPoint.order = 1;
    basicPoint.enabled = YES;
    [realm addObject:basicPoint];
    
    basicPoint = [[VLDBasicPoint alloc] init];
    basicPoint.name = @"Eucaristía";
    basicPoint.descriptionText = @"";
    basicPoint.order = 2;
    basicPoint.enabled = YES;
    [realm addObject:basicPoint];
    
    basicPoint = [[VLDBasicPoint alloc] init];
    basicPoint.name = @"Rosario";
    basicPoint.descriptionText = @"";
    basicPoint.order = 3;
    basicPoint.enabled = YES;
    [realm addObject:basicPoint];
    
    basicPoint = [[VLDBasicPoint alloc] init];
    basicPoint.name = @"Lectura";
    basicPoint.descriptionText = @"";
    basicPoint.order = 4;
    basicPoint.enabled = YES;
    [realm addObject:basicPoint];
    
    [realm commitWriteTransaction];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsDatabaseSeeded];
}

@end
