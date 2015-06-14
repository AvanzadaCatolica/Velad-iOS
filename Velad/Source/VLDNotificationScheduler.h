//
//  VLDNotificationScheduler.h
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VLDBasicPoint;

extern NSString * const VLDBasicPointUUIDUserInfoKey;

@interface VLDNotificationScheduler : NSObject

- (void)scheduleNotificationForBasicPoint:(VLDBasicPoint *)basicPoint
                                     time:(NSDate *)time
                                     days:(NSArray *)days;

@end
