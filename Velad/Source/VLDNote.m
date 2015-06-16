//
//  VLDNote.m
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDNote.h"

@interface VLDNote ()

@end

@implementation VLDNote

#pragma mark - Public methods

+ (RLMResults *)confessableNotesBetweenStartDate:(NSDate *)startDate
                                         endDate:(NSDate *)endDate {
    RLMResults *results = [[VLDNote objectsWhere:@"state == %d AND date BETWEEN {%@, %@}", VLDNoteStateConfessable, startDate, endDate] sortedResultsUsingProperty:@"date" ascending:NO];
    return results;
}

+ (RLMResults *)notesBetweenStartDate:(NSDate *)startDate
                              endDate:(NSDate *)endDate {
    RLMResults *results = [[VLDNote objectsWhere:@"date BETWEEN {%@, %@}", startDate, endDate] sortedResultsUsingProperty:@"date" ascending:NO];
    return results;
}

+ (NSArray *)stateSymbols {
    return @[@"Regular", @"Confesable", @"Confesado"];
}

+ (VLDNoteState)stateForSymbol:(NSString *)symbol {
    return [[self stateSymbols] indexOfObject:symbol];
}

+ (NSString *)symbolForState:(VLDNoteState)state {
    return [self stateSymbols][state];
}

@end