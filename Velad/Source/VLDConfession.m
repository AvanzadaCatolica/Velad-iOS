//
//  VLDConfession.m
//  Velad
//
//  Created by Renzo Crisóstomo on 28/08/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDConfession.h"

@implementation VLDConfession

+ (VLDConfession *)lastConfession {
    RLMResults *allConfessions = [[VLDConfession allObjects] sortedResultsUsingProperty:@"date" ascending:NO];
    return [allConfessions firstObject];
}

@end
