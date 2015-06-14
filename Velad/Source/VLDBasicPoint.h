//
//  VLDBasicPoint.h
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/RLMObject.h>

@class RLMResults;
@class VLDAlert;

@interface VLDBasicPoint : RLMObject

@property NSString *UUID;
@property NSString *name;
@property NSInteger order;
@property (getter=isEnabled) BOOL enabled;
@property NSString *descriptionText;
@property VLDAlert *alert;

+ (RLMResults *)basicPoints;

@end
