//
//  UITableViewCell+VLDAdditions.m
//  Velad
//
//  Created by Renzo Crisóstomo on 25/07/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "UITableViewCell+VLDAdditions.h"

@implementation UITableViewCell (VLDAdditions)

- (CGFloat)separatorDisplacement {
    if ([UIScreen mainScreen].scale == 3.0) {
        return 20;
    } else {
        return 15;
    }
}

@end
