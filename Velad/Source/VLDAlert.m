//
//  VLDAlert.m
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDAlert.h"

@implementation VLDAlert

- (NSArray *)weekDaySymbols {
    NSMutableArray *symbols = [NSMutableArray array];
    for (VLDWeekDay *weekDay in self.weekDays) {
        [symbols addObject:weekDay.name];
    }
    return [symbols copy];
}

@end
