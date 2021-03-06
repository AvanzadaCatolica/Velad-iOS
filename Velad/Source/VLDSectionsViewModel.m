//
//  VLDTodayViewModel.m
//  Velad
//
//  Created by Renzo Crisóstomo on 01/08/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDSectionsViewModel.h"

@implementation VLDSectionsViewModel

- (instancetype)initWithSectionTitles:(NSArray *)sectionTitles
                             sections:(NSArray *)sections {
    self = [super init];
    if (self) {
        _sectionTitles = sectionTitles;
        _sections = sections;
    }
    
    return self;
}

- (NSUInteger)totalCount {
    NSUInteger totalCount = 0;
    for (NSArray *section in self.sections) {
        totalCount += section.count;
    }
    return totalCount;
}

@end
