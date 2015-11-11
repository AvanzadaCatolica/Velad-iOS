//
//  VLDAlert.h
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Realm/RLMObject.h"
#import "Realm/RLMArray.h"
#import "VLDWeekday.h"

@interface VLDAlert : RLMObject

@property NSDate *time;
@property RLMArray<VLDWeekDay> *weekDays;

- (NSArray *)weekDaySymbols;
- (void)deleteAlertOnRealm:(RLMRealm *)realm;

@end
