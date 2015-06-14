//
//  VLDWeekViewModel.m
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDWeekViewModel.h"

@implementation VLDWeekViewModel

- (instancetype)initWithBasicPoint:(VLDBasicPoint *)basicPoint
                         weekCount:(NSUInteger)weekCount {
    self = [super init];
    if (self) {
        _basicPoint = basicPoint;
        _weekCount = weekCount;
    }
    
    return self;
}

@end
