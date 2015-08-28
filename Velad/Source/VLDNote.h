//
//  VLDNote.h
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Realm/Realm.h>
#import "VLDNoteFilterViewController.h"

typedef NS_ENUM(NSInteger, VLDNoteState) {
    VLDNoteStateRegular,
    VLDNoteStateConfessable,
    VLDNoteStateConfessed,
    VLDNoteStateGuidance,
    VLDNoteUndefined = NSIntegerMax
};

@interface VLDNote : RLMObject

@property NSString *text;
@property VLDNoteState state;
@property NSDate *date;

+ (RLMResults *)allNotes;
+ (RLMResults *)notesWithState:(VLDNoteState)state;
+ (RLMResults *)notesBetweenStartDate:(NSDate *)startDate
                              endDate:(NSDate *)endDate;
+ (NSArray *)stateSymbols;
+ (VLDNoteState)stateForSymbol:(NSString *)symbol;
+ (NSString *)symbolForState:(VLDNoteState)state;
+ (NSString *)formattedDateForNote:(VLDNote *)note;
+ (VLDNoteState)stateForFilterType:(VLDNoteFilterType)filterType;

@end
