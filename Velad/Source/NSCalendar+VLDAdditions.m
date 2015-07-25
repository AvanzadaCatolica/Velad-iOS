//
//  NSCalendar+VLDAdditions.m
//  Velad
//
//  Created by Renzo Crisóstomo on 25/07/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "NSCalendar+VLDAdditions.h"

NSString *const VLDCalendarShouldStartOnMondayKey = @"VLDCalendarShouldStartOnMondayKey";

@implementation NSCalendar (VLDAdditions)

+ (NSCalendar *)vld_preferredCalendar {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL calendarShouldStartOnMonday = [[userDefaults objectForKey:VLDCalendarShouldStartOnMondayKey] boolValue];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if (calendarShouldStartOnMonday) {
        calendar.firstWeekday = 2;
    }
    return calendar;
}

@end
