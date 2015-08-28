//
//  NSDate+VLDAdditions.h
//  Velad
//
//  Created by Renzo Crisóstomo on 20/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (VLDAdditions)

- (BOOL)vld_isToday;
- (NSDate *)vld_startOfTheWeek;
- (NSString *)vld_weekdaySymbol;
- (BOOL)vld_isSameDay:(NSDate *)date;

@end
