//
//  VLDReportsViewModel.h
//  Velad
//
//  Created by Renzo Crisóstomo on 20/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLDReportsViewModel : NSObject

@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) NSUInteger count;

- (instancetype)initWithDate:(NSDate *)date
                       count:(NSUInteger)count;

@end
