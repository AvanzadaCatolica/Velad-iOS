//
//  VLDRecord.h
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "RLMObject.h"

@class VLDBasicPoint;

@interface VLDRecord : RLMObject

@property NSDate *date;
@property VLDBasicPoint *basicPoint;
@property NSString *notes;

+ (RLMResults *)recordForBasicPoint:(VLDBasicPoint *)basicPoint
                             onDate:(NSDate *)date;

@end
