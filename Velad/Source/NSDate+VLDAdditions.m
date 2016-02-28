//
//  NSDate+VLDAdditions.m
//  Velad
//
//  Created by Renzo Crisóstomo on 20/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "NSDate+VLDAdditions.h"
#import "NSCalendar+VLDAdditions.h"

@implementation NSDate (VLDAdditions)

- (BOOL)vld_isToday {
    NSCalendar *calendar = [NSCalendar vld_preferredCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                               fromDate:[NSDate date]];
    NSDate *today = [calendar dateFromComponents:components];
    components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                             fromDate:self];
    NSDate *selfDate = [calendar dateFromComponents:components];
    return [selfDate isEqualToDate:today];
}

- (NSDate *)vld_startOfTheWeek {
    NSDate *periodStart;
    NSTimeInterval timeInterval;
    [[NSCalendar vld_preferredCalendar] rangeOfUnit:NSWeekCalendarUnit
                                          startDate:&periodStart
                                           interval:&timeInterval
                                            forDate:self];
    return periodStart;
}

- (NSString *)vld_weekdaySymbol {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"es"];
    [dateFormatter setDateFormat: @"EEEE"];
    return [dateFormatter stringFromDate:self];
}

- (BOOL)vld_isSameDay:(NSDate *)date {
    NSDate *strippedDate = [date vld_stripTime];
    NSDate *selfStrippedDate = [self vld_stripTime];
    return [strippedDate isEqualToDate:selfStrippedDate];
}

- (NSDate *)vld_stripTime {
    NSCalendar *calendar = [NSCalendar vld_preferredCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                               fromDate:self];
    NSDate *strippedDate = [calendar dateFromComponents:components];
    return strippedDate;
}

@end
