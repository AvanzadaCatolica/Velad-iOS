//
//  VLDEncouragement.h
//  Velad
//
//  Created by Renzo Crisóstomo on 07/02/16.
//  Copyright © 2016 MAC. All rights reserved.
//

#import <Realm/Realm.h>
#import <UIKit/UIKit.h>

@interface VLDDate : RLMObject

@property NSDate *date;

+ (VLDDate *)date:(NSDate *)date;

@end

RLM_ARRAY_TYPE(VLDDate)

@interface VLDEncouragement : RLMObject

@property (getter=isEnabled) BOOL enabled;
@property NSInteger percentage;
@property RLMArray<VLDDate> *shownDates;

@end
