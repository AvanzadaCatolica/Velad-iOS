//
//  VLDWeekday.h
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface VLDWeekDay : RLMObject

@property NSString *name;

@end

RLM_ARRAY_TYPE(VLDWeekDay)
