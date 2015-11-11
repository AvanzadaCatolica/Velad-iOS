//
//  VLDBasicPoint.h
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "Realm/RLMObject.h"
#import "Realm/RLMArray.h"
#import "VLDWeekday.h"

@class RLMResults;
@class VLDAlert;

@interface VLDBasicPoint : RLMObject

@property NSString *UUID;
@property NSString *name;
@property (getter=isEnabled) BOOL enabled;
@property NSString *descriptionText;
@property VLDAlert *alert;
@property RLMArray<VLDWeekDay> *weekDays;

- (NSArray<NSString *> *)weekDaySymbols;
- (void)deleteBasicPointInRealm:(RLMRealm *)realm;
- (NSUInteger)possibleWeekDaysCountUntilCurrentWeekDay;

@end

RLM_ARRAY_TYPE(VLDBasicPoint)
