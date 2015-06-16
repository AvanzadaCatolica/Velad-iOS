//
//  VLDSecurity.h
//  Velad
//
//  Created by Renzo Crisóstomo on 16/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Realm/Realm.h>

typedef NS_ENUM(NSInteger, VLDSecurityState) {
    VLDSecurityStateOnColdStart,
    VLDSecurityStateOnOpen
};

@interface VLDSecurity : RLMObject

@property (getter=isEnabled) BOOL enabled;
@property VLDSecurityState state;

+ (NSArray *)stateSymbols;
+ (VLDSecurityState)stateForSymbol:(NSString *)symbol;
+ (NSString *)symbolForState:(VLDSecurityState)state;

@end
