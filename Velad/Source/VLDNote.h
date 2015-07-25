//
//  VLDNote.h
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Realm/Realm.h>

typedef NS_ENUM(NSInteger, VLDNoteState) {
    VLDNoteStateRegular,
    VLDNoteStateConfessable,
    VLDNoteStateConfessed,
    VLDNoteStateGuidance
};

@interface VLDNote : RLMObject

@property NSString *text;
@property VLDNoteState state;
@property NSDate *date;

+ (RLMResults *)guidanceNotesBetweenStartDate:(NSDate *)startDate
                                      endDate:(NSDate *)endDate;
+ (RLMResults *)confessableNotesBetweenStartDate:(NSDate *)startDate
                                         endDate:(NSDate *)endDate;
+ (RLMResults *)notesBetweenStartDate:(NSDate *)startDate
                              endDate:(NSDate *)endDate;
+ (NSArray *)stateSymbols;
+ (VLDNoteState)stateForSymbol:(NSString *)symbol;
+ (NSString *)symbolForState:(VLDNoteState)state;

@end
