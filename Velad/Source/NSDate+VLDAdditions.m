//
//  NSDate+VLDAdditions.m
//  Velad
//
//  Created by Renzo Crisóstomo on 20/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "NSDate+VLDAdditions.h"

@implementation NSDate (VLDAdditions)

- (BOOL)isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                               fromDate:[NSDate date]];
    NSDate *today = [calendar dateFromComponents:components];
    components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                             fromDate:self];
    NSDate *selfDate = [calendar dateFromComponents:components];
    return [selfDate isEqualToDate:today];
}

@end
