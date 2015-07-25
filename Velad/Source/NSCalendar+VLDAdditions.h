//
//  NSCalendar+VLDAdditions.h
//  Velad
//
//  Created by Renzo Crisóstomo on 25/07/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const VLDCalendarShouldStartOnMondayKey;

@interface NSCalendar (VLDAdditions)

+ (NSCalendar *)vld_preferredCalendar;

@end
