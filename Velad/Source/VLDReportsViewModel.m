//
//  VLDReportsViewModel.m
//  Velad
//
//  Created by Renzo Crisóstomo on 20/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDReportsViewModel.h"

@implementation VLDReportsViewModel

- (instancetype)initWithDate:(NSDate *)date
                       count:(NSUInteger)count {
    self = [super init];
    if (self) {
        _date = date;
        _count = count;
    }
    
    return self;
}

@end
