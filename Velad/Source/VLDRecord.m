//
//  VLDRecord.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDRecord.h"
#import <Realm/Realm.h>

@implementation VLDRecord

#pragma mark - Public methods

+ (RLMResults *)recordForBasicPoint:(VLDBasicPoint *)basicPoint
                             onDate:(NSDate *)date {
    RLMResults *results = [VLDRecord objectsWhere:@"basicPoint == %@ AND date == %@", basicPoint, date];
    return results;
}

+ (RLMResults *)recordsForBasicPoint:(VLDBasicPoint *)basicPoint
                    betweenStartDate:(NSDate *)startDate
                             endDate:(NSDate *)endDate {
    RLMResults *results = [VLDRecord objectsWhere:@"basicPoint == %@ AND date BETWEEN {%@, %@}", basicPoint, startDate, endDate];
    return results;
}

@end
