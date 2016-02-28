//
//  VLDEncouragement.m
//  Velad
//
//  Created by Renzo Crisóstomo on 07/02/16.
//  Copyright © 2016 MAC. All rights reserved.
//

#import "VLDEncouragement.h"

@implementation VLDDate

+ (VLDDate *)date:(NSDate *)date {
    RLMResults *results = [VLDDate objectsWhere:@"date == %@", date];
    return [results firstObject];
}

@end

@implementation VLDEncouragement

@end
