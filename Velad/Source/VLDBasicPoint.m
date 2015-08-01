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

@end
