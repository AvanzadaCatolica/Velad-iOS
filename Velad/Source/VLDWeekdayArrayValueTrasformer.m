//
//  VLDWeekdayArrayValueTrasformer.m
//  Velad
//
//  Created by Renzo Crisóstomo on 26/07/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDWeekdayArrayValueTrasformer.h"

@implementation VLDWeekdayArrayValueTrasformer

+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if (!value) {
        return nil;
    }
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)value;
        if (array.count == 1) {
            return [[array firstObject] capitalizedString];
        } else {
            return [NSString stringWithFormat:@"%ld días", (long)array.count];
        }
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value capitalizedString];
    }
    return nil;
}

@end
