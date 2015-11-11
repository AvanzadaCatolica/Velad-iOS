//
//  VLDBasicPoint.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDBasicPoint.h"
#import "VLDGroup.h"
#import "VLDAlert.h"
#import "NSDate+VLDAdditions.h"
#import "Realm/RLMRealm.h"

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

- (NSUInteger)possibleWeekDaysCountUntilWeekDaySymbol:(NSString *)untilWeekDaySymbol {
    NSUInteger count = 0;
    NSArray *weekDaySymbols = [self weekDaySymbols];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"es"];
    NSArray *allWeekDaySymbols = [dateFormatter weekdaySymbols];
    for (NSString *weekDaySymbol in allWeekDaySymbols) {
        if ([weekDaySymbols containsObject:weekDaySymbol]) {
            count++;
        }
        if ([weekDaySymbol isEqualToString:untilWeekDaySymbol]) {
            break;
        }
    }
    return count;
}

@end
