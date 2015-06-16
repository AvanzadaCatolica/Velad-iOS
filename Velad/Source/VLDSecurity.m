//
//  VLDSecurity.m
//  Velad
//
//  Created by Renzo Crisóstomo on 16/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDSecurity.h"

@implementation VLDSecurity

+ (NSArray *)stateSymbols {
    return @[@"Al iniciar", @"Al abrir"];
}

+ (VLDSecurityState)stateForSymbol:(NSString *)symbol {
    return [[self stateSymbols] indexOfObject:symbol];
}

+ (NSString *)symbolForState:(VLDSecurityState)state {
    return [self stateSymbols][state];
}

@end
