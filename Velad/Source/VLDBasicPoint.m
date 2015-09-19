//
//  VLDBasicPoint.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDBasicPoint.h"
#import <Realm/Realm.h>
#import "VLDGroup.h"
#import "VLDAlert.h"
#import "NSDate+VLDAdditions.h"

@interface VLDBasicPoint ()

@end

@implementation VLDBasicPoint

#pragma makr - Public methods

- (NSArray *)weekDaySymbols {
    NSMutableArray *symbols = [NSMutableArray array];
    for (VLDWeekDay *weekDay in self.weekDays) {
        [symbols addObject:weekDay.name];
    }
    return [symbols copy];
}

- (void)deleteBasicPointInRealm:(RLMRealm *)realm {
    [realm deleteObjects:self.weekDays];
    [self.alert deleteAlertOnRealm:realm];
}

- (NSUInteger)possibleWeekDaysCountUntilCurrentWeekDay {
    NSUInteger count = 0;
    NSDate *today = [NSDate date];
    NSString *symbol = [today vld_weekdaySymbol];
    NSArray *weekDaySymbols = [self weekDaySymbols];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"es"];
    NSArray *allWeekDaySymbols = [dateFormatter weekdaySymbols];
    for (NSString *weekDaySymbol in allWeekDaySymbols) {
        if ([weekDaySymbols containsObject:weekDaySymbol]) {
            count++;
        }
        if ([weekDaySymbol isEqualToString:symbol]) {
            break;
        }
    }
    return count;
}

@end
