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

@interface VLDBasicPoint : RLMObject

@property NSString *name;
@property NSInteger order;
@property (getter=isEnabled) BOOL enabled;

+ (RLMResults *)basicPoints;

@end
