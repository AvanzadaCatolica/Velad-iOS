//
//  VLDConfession.m
//  Velad
//
//  Created by Renzo Crisóstomo on 28/08/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDConfession.h"

@implementation VLDConfession

+ (VLDConfession *)lastConfession {
    RLMResults *allConfessions = [[VLDConfession allObjects] sortedResultsUsingProperty:@"date" ascending:NO];
    return [allConfessions firstObject];
}

+ (NSString *)formattedDateForConfession:(VLDConfession *)confession {
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd/MM/yyyy";
    });
    return [dateFormatter stringFromDate:confession.date];
}

@end
