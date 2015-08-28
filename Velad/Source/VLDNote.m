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

+ (RLMResults *)allNotes {
    RLMResults *results = [[VLDNote allObjects] sortedResultsUsingProperty:@"date" ascending:NO];
    return results;
}

+ (RLMResults *)notesWithState:(VLDNoteState)state {
    RLMResults *results = [[VLDNote objectsWhere:@"state == %d", state] sortedResultsUsingProperty:@"date" ascending:NO];
    return results;
}

+ (RLMResults *)notesBetweenStartDate:(NSDate *)startDate
                              endDate:(NSDate *)endDate {
    RLMResults *results = [[VLDNote objectsWhere:@"date BETWEEN {%@, %@}", startDate, endDate] sortedResultsUsingProperty:@"date" ascending:NO];
    return results;
}

+ (NSArray *)stateSymbols {
    return @[@"Regular", @"Confesable", @"Confesado", @"Guiamiento"];
}

+ (VLDNoteState)stateForSymbol:(NSString *)symbol {
    return [[self stateSymbols] indexOfObject:symbol];
}

+ (NSString *)symbolForState:(VLDNoteState)state {
    return [self stateSymbols][state];
}

+ (NSString *)formattedDateForNote:(VLDNote *)note {
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd/MM/yyyy";
    });
    return [dateFormatter stringFromDate:note.date];
}

+ (VLDNoteState)stateForFilterType:(VLDNoteFilterType)filterType {
    switch (filterType) {
        case VLDNoteFilterTypeRegular:
            return VLDNoteStateRegular;
        case VLDNoteFilterTypeConfessable:
            return VLDNoteStateConfessable;
        case VLDNoteFilterTypeConfessed:
            return VLDNoteStateConfessed;
        case VLDNoteFilterTypeGuidance:
            return VLDNoteStateGuidance;
        default:
            return VLDNoteUndefined;
    }
}

@end
