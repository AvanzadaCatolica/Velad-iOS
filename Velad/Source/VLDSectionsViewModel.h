//
//  VLDTodayViewModel.h
//  Velad
//
//  Created by Renzo Crisóstomo on 01/08/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLDSectionsViewModel : NSObject

@property (nonatomic, readonly) NSArray *sectionTitles;
@property (nonatomic, readonly) NSArray *sections;

- (instancetype)initWithSectionTitles:(NSArray *)sectionTitles
                             sections:(NSArray *)sections NS_DESIGNATED_INITIALIZER;

@end
