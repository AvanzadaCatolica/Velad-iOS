//
//  VLDProfile.m
//  Velad
//
//  Created by Renzo Crisóstomo on 16/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDProfile.h"
#import "NSString+VLDAdditions.h"

@implementation VLDProfile

- (NSString *)information {
    NSMutableString *information = [NSMutableString string];
    [information appendFormat:@"Nombre: %@\n", self.name];
    if (![self.circle vld_isEmpty]) {
        [information appendFormat:@"Círculo: %@\n", self.circle];
    }
    if (![self.group vld_isEmpty]) {
        [information appendFormat:@"Grupo: %@\n", self.group];
    }
    [information appendString:@"\n"];
    return [information copy];
}

@end
