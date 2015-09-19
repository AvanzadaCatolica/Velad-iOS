//
//  NSDateFormatter+VLDAdditions.m
//  Velad
//
//  Created by Renzo Crisostomo on 19/09/15.
//  Copyright © 2015 MAC. All rights reserved.
//

#import "NSDateFormatter+VLDAdditions.h"
#import <objc/runtime.h>
#import "NSCalendar+VLDAdditions.h"

@implementation NSDateFormatter (VLDAdditions)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(weekdaySymbols);
        SEL swizzledSelector = @selector(vld_weekdaySymbols);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (NSArray *)vld_weekdaySymbols {
    NSArray *weekdaySymbols = [self vld_weekdaySymbols];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL calendarShouldStartOnMonday = [userDefaults boolForKey:VLDCalendarShouldStartOnMondayKey];
    if (!calendarShouldStartOnMonday) {
        return weekdaySymbols;
    }
    return [[weekdaySymbols subarrayWithRange:NSMakeRange(1, weekdaySymbols.count - 1)] arrayByAddingObject:weekdaySymbols.firstObject];
}


@end
