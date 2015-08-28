//
//  VLDConfession.h
//  Velad
//
//  Created by Renzo Crisóstomo on 28/08/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Realm/Realm.h>

@interface VLDConfession : RLMObject

@property NSDate *date;

+ (VLDConfession *)lastConfession;

@end
