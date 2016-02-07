//
//  VLDEncouragement.h
//  Velad
//
//  Created by Renzo Crisóstomo on 07/02/16.
//  Copyright © 2016 MAC. All rights reserved.
//

#import <Realm/Realm.h>
#import <UIKit/UIKit.h>

@interface VLDEncouragement : RLMObject

@property (getter=isEnabled) BOOL enabled;
@property NSInteger percentage;

@end
