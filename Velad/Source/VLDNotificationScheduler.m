//
//  VLDNotificationScheduler.m
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDNotificationScheduler.h"
#import <UIKit/UIKit.h>
#import "VLDBasicPoint.h"
#import <Realm/Realm.h>
#import "VLDAlert.h"

@interface VLDNotificationScheduler ()

@property (nonatomic, strong) NSArray *weekDaySymbols;

- (void)scheduleNotification:(UILocalNotification *)notification
                         day:(NSString *)day
                        time:(NSDate *)time;
- (NSInteger)weekdayForDay:(NSString *)day;

@end

static NSTimeInterval const kWeekTimeInterval = 7 * 24 * 60 * 60;
NSString * const VLDBasicPointUUIDUserInfoKey = @"VLDBasicPointUUIDUserInfoKey";

@implementation VLDNotificationScheduler

#pragma mark - Public methods

- (void)scheduleNotificationForBasicPoint:(VLDBasicPoint *)basicPoint
                                     time:(NSDate *)time
                                     days:(NSArray *)days {
    for (NSString *day in days) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        if ([localNotification respondsToSelector:@selector(alertTitle)]) {
            localNotification.alertTitle = @"Velad te recuerda";
        }
        localNotification.alertBody = [NSString stringWithFormat:@"Alerta sobre el punto básico: %@", basicPoint.name];
        localNotification.userInfo = @{VLDBasicPointUUIDUserInfoKey: basicPoint.UUID};
        [self scheduleNotification:localNotification
                               day:day
                              time:time];
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    if (basicPoint.alert) {
        [realm deleteObject:basicPoint.alert];
    }
    VLDAlert *alert = [[VLDAlert alloc] init];
    alert.time = time;
    for (NSString *day in days) {
        VLDWeekDay *weekDay = [[VLDWeekDay alloc] init];
        weekDay.name = day;
        [alert.weekDays addObject:weekDay];
    }
    basicPoint.alert = alert;
    
    [realm commitWriteTransaction];
}

#pragma mark - Private methods

- (NSArray *)weekDaySymbols {
    if (_weekDaySymbols) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"es"];
        _weekDaySymbols = [dateFormatter weekdaySymbols];
    }
    return _weekDaySymbols;
}

- (NSInteger)weekdayForDay:(NSString *)day {
    return [_weekDaySymbols indexOfObject:[day lowercaseString]] + 1;
}

- (void)scheduleNotification:(UILocalNotification *)notification
                         day:(NSString *)day
                        time:(NSDate *)time {
    NSDate *today = [NSDate date];
    NSDate *targetDate = [today dateByAddingTimeInterval:kWeekTimeInterval];
    NSDateComponents *timeComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:time];
    NSDateComponents *targetComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:targetDate];
    [targetComponents setWeekday:[self weekdayForDay:day]];
    [targetComponents setHour:timeComponents.hour];
    [targetComponents setMinute:timeComponents.minute];
    [targetComponents setSecond:0];
    NSDate *fireDate = [[NSCalendar currentCalendar] dateFromComponents:targetComponents];
    notification.fireDate = fireDate;
    notification.repeatInterval = kWeekTimeInterval;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
