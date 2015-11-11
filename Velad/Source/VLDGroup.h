//
//  VLDGroup.h
//  Velad
//
//  Created by Renzo Crisóstomo on 01/08/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "Realm/RLMObject.h"
#import "Realm/RLMArray.h"
#import "Realm/RLMResults.h"
#import "VLDBasicPoint.h"

@interface VLDGroup : RLMObject

@property NSString *name;
@property RLMArray<VLDBasicPoint> *basicPoints;
@property NSInteger order;

+ (RLMResults *)sortedGroups;

@end
