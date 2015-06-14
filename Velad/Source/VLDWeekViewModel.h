//
//  VLDWeekViewModel.h
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLDBasicPoint.h"

@interface VLDWeekViewModel : NSObject

@property (nonatomic, readonly) VLDBasicPoint *basicPoint;
@property (nonatomic, readonly) NSUInteger weekCount;

- (instancetype)initWithBasicPoint:(VLDBasicPoint *)basicPoint
                         weekCount:(NSUInteger)weekCount;

@end
