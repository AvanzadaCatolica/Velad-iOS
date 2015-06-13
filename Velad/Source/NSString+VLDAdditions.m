//
//  NSString+VLDAdditions.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "NSString+VLDAdditions.h"

@implementation NSString (VLDAdditions)

- (BOOL)vld_isEmpty {
    if ([self length] == 0) {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

@end
